import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_application_2/model/element/stroke.dart';
import 'package:flutter_application_2/model/store/canvas_store.dart';
import 'package:flutter_application_2/model/algorithm/geometry_algorithm.dart';

enum LassoStep {
  /// 画线
  drawLine,

  /// 闭合
  closeLine,

}

mixin Lasso on CanvasStore {
  /// 套索行为阶段
  LassoStep lassoStep = LassoStep.drawLine;

  /// 套索的路径坐标点集合
  List<ui.Offset> trackPointList = [];

  Path get lassoPath {
    Path _path = Path();
    switch (lassoStep) {
      case LassoStep.drawLine:
        trackPointList.asMap().forEach((index, point) {
          if (index == 0) {
            _path.moveTo(point.dx, point.dy);
          } else {
            _path.lineTo(point.dx, point.dy);
          }
        });
        break;
      case LassoStep.closeLine:
        if (trackPointList.isNotEmpty && trackPointList.length > 2) {
          trackPointList.asMap().forEach((index, point) {
            if (index == 0) {
              _path.moveTo(point.dx, point.dy);
            } else {
              _path.lineTo(point.dx, point.dy);
            }
          });
          _path.close();
        }
        break;
    }
    return _path;
  }

  /// 路径绘制样式
  ui.Paint get lassoPaint => ui.Paint()
    ..color = Colors.blue
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke
    ..isAntiAlias = true
    ..strokeJoin = StrokeJoin.miter;
}

extension LassoAction on Lasso {
  resetLasso() {
    trackPointList.clear();
    lassoStep = LassoStep.drawLine;
    selectedArea.trackPath.reset();
    selectedArea.selectedStrokeList.clear();
  }

  switchLassoStep(
    LassoStep step,
  ) {
    lassoStep = step;
  }

  addTrackPoint(ui.Offset offset) {
    trackPointList.add(transformToCanvasOffset(offset));
  }

  /// 检查是否命中套索区域内
  bool hitLassoCloseArea(Offset position) =>
      selectedArea.trackPath.contains(transformToCanvasOffset(position));

  /// 获取被框选的画迹
  List<Stroke> getSelectedStrokeList() => strokeList
      .where((stroke) => GeometryAlgorithm.isClosePathOverlay(
          originPath: selectedArea.trackPath, targetPath: stroke.path))
      .toList();

  /// 移动套索及其所选元素
  translate(ui.Offset offset) {
    for (var item in selectedArea.selectedStrokeList) {
      item.translate(offset);
    }
    final matrix4 = Matrix4.identity()..translate(offset.dx, offset.dy);
    selectedArea.trackPath = selectedArea.trackPath.transform(matrix4.storage);
  }
}

extension LassoGesture on Lasso {
  onDrawLineDown(PointerDownEvent details) {
    addTrackPoint(transformToCanvasOffset(details.localPosition));
  }

  onDrawLineMove(PointerMoveEvent details) {
    addTrackPoint(transformToCanvasOffset(details.localPosition));
    selectedArea.trackPath = Path.from(lassoPath);
  }

  onDrawLineUp(PointerUpEvent details) {
    switchLassoStep(LassoStep.closeLine);
    var selectedStrokeList = getSelectedStrokeList();
    if (selectedStrokeList.isEmpty) {
      resetLasso();
      return;
    }
    selectedArea.selectedStrokeList = selectedStrokeList;
    selectedArea.trackPath = Path.from(lassoPath);
  }

  onCloseLineDown(PointerDownEvent details) {
    if (!hitLassoCloseArea(details.localPosition)) {
      resetLasso();
    }
  }

  onCloseLineMove(PointerMoveEvent details) {
    translate(details.localDelta);
  }

  onLassoDown(
    PointerDownEvent details,
  ) {
    switch (lassoStep) {
      case LassoStep.drawLine:
        onDrawLineDown(details);
        break;
      case LassoStep.closeLine:
        onCloseLineDown(details);
        break;
    }
  }

  onLassoMove(
    PointerMoveEvent details,
  ) {
    switch (lassoStep) {
      case LassoStep.drawLine:
        onDrawLineMove(details);
        break;
      case LassoStep.closeLine:
        onCloseLineMove(details);
        break;
    }
  }

  onLassoUp(
    PointerUpEvent details,
  ) {
    switch (lassoStep) {
      case LassoStep.drawLine:
        onDrawLineUp(details);
        break;
      case LassoStep.closeLine:
        break;
    }
  }
}
