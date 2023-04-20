import 'package:flutter/material.dart';
import '../../type/elementType/whiteboard_element.dart';

enum LassoStep {
  /// 画线
  drawLine,

  /// 闭合
  close,
}

class LassoConfig {
  /// 套索行为阶段
  LassoStep lassoStep = LassoStep.drawLine;

  /// 套索的路径点
  final List<Offset> lassoPathPointList = [];

  /// 闭合区域对应的path
  Path closedShapePath = Path();

  /// 拖拽偏移量
  Offset dragLassoOffset = Offset.zero;

  /// 存储被套索选中的元素
  List<WhiteBoardElement> selectedElementList = [];

  /// 是否处于拖拽状态
  bool isDrag = false;

  /// 路径绘制样式
  Paint get paint => Paint()
    ..color = Colors.blue
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke
    ..isAntiAlias = true
    ..strokeJoin = StrokeJoin.miter;

  /// 套索路径
  Path? get dashesLinePath {
    if (lassoPathPointList.isEmpty) return Path();
    final Path path = Path();
    lassoPathPointList.asMap().forEach((index, point) {
      if (index == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    });
    return path;
  }

  
}
