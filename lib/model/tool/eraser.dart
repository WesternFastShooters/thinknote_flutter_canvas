import 'dart:ui' as ui;
import 'package:flutter/gestures.dart';
import 'package:flutter_application_2/model/algorithm/geometry_algorithm.dart';
import 'package:flutter_application_2/model/store/canvas_store.dart';

mixin Eraser on CanvasStore {
  /// 当前橡皮擦的位置
  ui.Offset? eraserPosition;

  setEraserPosition(ui.Offset position) {
    eraserPosition = transformToCanvasOffset(position);
  }

  /// 橡皮擦的半径
  double eraserRadius = 10.0;

  /// 橡皮擦移动轨迹坐标点集合
  List<ui.Offset> eraserTrackPointList = <ui.Offset>[];

  /// 橡皮擦移动轨迹path
  ui.Path get eraserTrackPath {
    var _path = ui.Path();
    if (eraserTrackPointList.isEmpty) return _path;
    _path.moveTo(eraserTrackPointList[0].dx, eraserTrackPointList[0].dy);
    for (int i = 1; i < eraserTrackPointList.length; ++i) {
      _path.lineTo(eraserTrackPointList[i].dx, eraserTrackPointList[i].dy);
    }
    return _path;
  }

  /// 橡皮擦范围Path
  ui.Path get eraserAreaPath => ui.Path()
    ..addOval(
        ui.Rect.fromCircle(center: eraserPosition!, radius: eraserRadius));

  /// 擦除
  erase() {
    if (eraserPosition == null) return;
    eraserTrackPointList.add(eraserPosition!);
    strokeList.removeWhere((item) {
      return GeometryAlgorithm.isPathIntersection(
              originPath: eraserTrackPath, targetPath: item.path) ||
          GeometryAlgorithm.isClosePathOverlay(
              originPath: eraserAreaPath, targetPath: item.path);
    });
  }

  /// 重置橡皮擦配置
  resetEraser() {
    eraserPosition = null;
    eraserRadius = 10.0;
    eraserTrackPointList.clear();
  }
}

extension EraserGesture on Eraser {
  onEraserDown(PointerDownEvent details) {
    if (eraserPosition == null) {
      setEraserPosition(details.localPosition);
      erase();
    }
  }

  onEraserMove(PointerMoveEvent details) {
    setEraserPosition(details.localPosition);
    erase();
  }

  onEraserUp(PointerUpEvent details) {
    resetEraser();
  }
}
