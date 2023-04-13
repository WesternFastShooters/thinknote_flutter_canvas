import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/type/elementType/element_container.dart';

enum LassoStep {
  /// 未开始套索
  none,

  /// 画线
  drawLine,

  /// 闭合
  close,
}

class LassoConfig {
  /// 套索行为阶段
  LassoStep lassoStep = LassoStep.drawLine;

  /// 套索的路径点
  List<Offset> lassoPathPoints = [];

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
    if(lassoPathPoints.isEmpty) return null;
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
    if(lassoPathPoints.isEmpty) return null;
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

  /// 套索是否可以封闭
  bool get isEmpty => lassoPathPoints.isEmpty;
  bool get isConvexity => lassoPathPoints.length > 2;
}
