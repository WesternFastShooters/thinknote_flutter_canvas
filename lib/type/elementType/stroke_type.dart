import 'package:flutter/material.dart';
import 'package:flutter_application_2/type/elementType/white_element.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'package:perfect_freehand/perfect_freehand.dart';

typedef StrokePoint = Point;

class Stroke extends WhiteElement {
  Stroke({
    required this.pointerId,
    required Map? option,
  }) {
    this.option = option;
  }
  factory Stroke.init() => Stroke(pointerId: -1, option: null);

  /// 笔画点集合
  List<StrokePoint> strokePoints = <StrokePoint>[]; // { dx,dy,pressure }[]

  /// 笔画id，用于区分不同的笔画，防止多个笔画同时绘制
  int pointerId = -1;

  /// 拖拽偏移量
  @override
  Offset dragOffset = Offset.zero;

  /// 笔画配置属性
  Map _option = {
    'size': 3.0,
    'thinning': 0.1,
    'smoothing': 0.5,
    'streamline': 0.5,
    'taperStart': 0.0,
    'capStart': true,
    'taperEnd': 0.1,
    'capEnd': true,
    'simulatePressure': true,
    'isComplete': false,
    'color': Colors.pink,
  };
  set option(Map? option) => _option = option ?? _option;
  Map get option => _option;

  @override
  Path get path {
    final _path = Path();
    final outlinePoints = getStroke(
      strokePoints,
      size: 3,
      thinning: 0.1,
      smoothing: 0.5,
      streamline: 0.5,
      taperStart: 0.0,
      capStart: true,
      taperEnd: 0.1,
      capEnd: true,
      simulatePressure: true,
      isComplete: true,
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

    var boundingBox = _path.getBounds();
    var topLeft = boundingBox.topLeft;
    topLeft += dragOffset;
    Matrix4 matrix = Matrix4.identity()..translate(topLeft.dx, topLeft.dy);
    _path.transform(matrix.storage);

    return _path;
  }

  Paint get paint => Paint()..color = option['color'];

  /// 判断笔画是否为空
  @override
  bool get isEmpty => path.getBounds().isEmpty;

  /// 存储笔画点
  storeStrokePoint(
      {required Offset position, required PointerEvent pointInfo}) {
    final strokePoint = pointInfo.kind == PointerDeviceKind.stylus
        ? StrokePoint(
            position.dx,
            position.dy,
            (pointInfo.pressure - pointInfo.pressureMin) /
                (pointInfo.pressureMax - pointInfo.pressureMin),
          )
        : StrokePoint(position.dx, position.dy);
    strokePoints.add(strokePoint);
  }
}
