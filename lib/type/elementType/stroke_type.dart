import 'package:flutter/material.dart';
import 'package:flutter_application_2/type/elementType/white_element.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'package:perfect_freehand/perfect_freehand.dart';

typedef StrokePoint = Point;

class Stroke extends WhiteElement {
  Stroke({
    required this.option,
    required List<StrokePoint> strokePoints,
  }) {
    this.strokePoints = strokePoints;
  }

  /// 拖拽偏移量
  @override
  Offset dragOffset = Offset.zero;

  /// 设置偏移量
  @override
  setDragOffset(Offset delta) {
    dragOffset += delta;
  }

  /// 笔画点集合
  List<StrokePoint> _strokePoints = <StrokePoint>[]; // { dx,dy,pressure }[]
  set strokePoints(List<StrokePoint> strokePoints) {
    _strokePoints = strokePoints;
  }

  List<StrokePoint> get strokePoints => dragOffset == Offset.zero
      ? _strokePoints
      : _strokePoints
          .map(
              (e) => StrokePoint(e.x + dragOffset.dx, e.y + dragOffset.dy, e.p))
          .toList();

  /// 笔画配置属性
  Map option;

  /// 画迹路径
  @override
  Path get path {
    var _path = Path();
    final outlinePoints = getStroke(
      strokePoints,
      size: option['size'],
      thinning: option['thinning'],
      smoothing: option['smoothing'],
      streamline: option['streamline'],
      taperStart: option['taperStart'],
      capStart: option['capStart'],
      taperEnd: option['taperEnd'],
      capEnd: option['capEnd'],
      simulatePressure: option['simulatePressure'],
      isComplete: option['isComplete'],
    );
    if (outlinePoints.isEmpty) {
      return _path;
    }
    if (outlinePoints.length < 2 && outlinePoints.isNotEmpty) {
      _path.addOval(Rect.fromCircle(
          center: Offset(outlinePoints[0].x, outlinePoints[0].y), radius: 1));
    } else {
      _path.moveTo(outlinePoints[0].x, outlinePoints[0].y);

      for (int i = 1; i < outlinePoints.length - 1; ++i) {
        final p0 = outlinePoints[i];
        final p1 = outlinePoints[i + 1];
        _path.quadraticBezierTo(
            p0.x, p0.y, (p0.x + p1.x) / 2, (p0.y + p1.y) / 2);
      }
    }

    return _path;
  }

  /// 画迹样式
  Paint get paint => Paint()..color = option['color'];

  /// 判断笔画是否为空
  @override
  bool get isEmpty => path.getBounds().isEmpty;

  /// 深拷贝
  @override
  Stroke deepCopy() {
    return Stroke(
      strokePoints: List.from(strokePoints),
      option: Map.from(option),
    );
  }
}
