import 'dart:ui';
import 'package:flutter_application_2/modal/board_modal.dart';
import 'package:flutter_application_2/modal/logic/freedraw_logic.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:perfect_freehand/perfect_freehand.dart';

class Stroke {
  final BoardModal boardModal = Get.find<BoardModal>();
  Stroke({int? pointerId, Map? option}) {
    this.option = option ?? {...this.option};
  }

  int pointerId = 0;
  Map option = {
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
  List<Point> strokePoints = []; // { dx,dy,pressure }[]
  Map get pathCanvas {
    final path = Path();
    Paint paint = Paint()..color = option['color'];
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
    if (outlinePoints.length < 2) {
      // 只画一个点
      path.addOval(Rect.fromCircle(
          center: Offset(outlinePoints[0].x, outlinePoints[0].y), radius: 1));
    } else {
      // 画线
      path.moveTo(outlinePoints[0].x, outlinePoints[0].y);
      for (var i = 1; i < outlinePoints.length; i++) {
        path.lineTo(outlinePoints[i].x, outlinePoints[i].y);
      }
    }
    return {'path': path, 'paint': paint};
  }
  bool get isEmpty => strokePoints.isEmpty;

  storeStrokePoint(PointerEvent details) {
    final offsetStrokePoint =
        boardModal.transformToCanvasPoint(details.localPosition);
    final strokePoint = details.kind == PointerDeviceKind.stylus
        ? StrokePoint(
            offsetStrokePoint.dx,
            offsetStrokePoint.dy,
            (details.pressure - details.pressureMin) /
                (details.pressureMax - details.pressureMin),
          )
        : StrokePoint(offsetStrokePoint.dx, offsetStrokePoint.dy);
    strokePoints.add(strokePoint);
  }

  
}
