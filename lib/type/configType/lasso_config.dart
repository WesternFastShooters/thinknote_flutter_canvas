import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum LassoStep {
  /// 画线
  drawLine,

  /// 闭合
  close,
}

class LassoConfig {
  /// 套索行为阶段
  LassoStep lassoStep = LassoStep.drawLine;
  setLassoStep(LassoStep step) {
    lassoStep = step;
  }

  /// 套索的路径点
  List<Offset> _lassoPathPoints = [];
  List<Offset> get lassoPathPoints => dragOffset == Offset.zero
      ? _lassoPathPoints
      : _lassoPathPoints.map((e) => e + dragOffset).toList();

  /// 拖拽偏移量
  Offset dragOffset = Offset.zero;

  /// 偏移量更改
  setDragOffset(Offset offset) {
    dragOffset += offset;
  }

  /// 路径绘制样式
  final Paint paint = Paint()
    ..color = Colors.blue
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke
    ..isAntiAlias = true
    ..strokeJoin = StrokeJoin.miter;

  /// 套索路径
  Path? get lassoPath {
    if (lassoPathPoints.isEmpty) return null;
    final Path path = Path();
    lassoPathPoints.asMap().forEach((index, point) {
      if (index == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    });
    return path;
  }

  /// 套索闭合区域path
  Path? get closedShapePath {
    if (lassoPathPoints.isEmpty) return null;
    final Path path = Path();
    lassoPathPoints.asMap().forEach((index, point) {
      if (index == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    });
    path.close();
    return path;
  }

  /// 套索虚线是否为空
  bool get isEmpty => lassoPathPoints.isEmpty;

  /// 套索是否可以封闭
  bool get isConvexity => lassoPathPoints.length > 2;

  /// 检查是否命中套索区域内
  bool checkHitLassoCloseArea(Offset position) => lassoPath!.contains(position);

  /// 添加套索虚线点
  addLassoPathPoint(Offset point) {
    lassoPathPoints.add(point);
  }

  /// 清空套索
  reset() {
    lassoStep = LassoStep.drawLine;
    _lassoPathPoints.clear();
    dragOffset = Offset.zero;
  }
}
