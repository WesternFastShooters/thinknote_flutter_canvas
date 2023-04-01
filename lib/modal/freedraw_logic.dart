import 'package:flutter/material.dart';
import 'package:flutter_application_2/modal/transform_logic.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'package:perfect_freehand/perfect_freehand.dart';

typedef StrokePoint = Point;

class FreeDrawLogic extends GetxController {
  /// 当前笔画的配置属性
  Map currentStrokeOption = {
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
    'color': Colors.green,
  };

  /// 当前笔画
  Stroke currentStroke = Stroke();

  /// 所有笔画
  List<Stroke> strokes = <Stroke>[];

  /// 自由绘画模式下，落笔触发逻辑
  void onPointerDown(PointerDownEvent details) {
    currentStrokeOption = {
      ...currentStrokeOption,
      'simulatePressure': details.kind != PointerDeviceKind.stylus,
    };
    if (currentStroke.pointerId == 0) {
      currentStroke =
          Stroke(pointerId: details.pointer, option: currentStrokeOption)
            ..storeStrokePoint(details);
      update();
    }
  }

  /// 自由绘画下，移笔触发逻辑
  void onPointerMove(PointerMoveEvent details) {
    if (details.pointer == currentStroke.pointerId) {
      currentStroke.storeStrokePoint(details);
      update();
    }
  }

  /// 自由绘画下，提笔触发逻辑
  void onPointerUp(PointerUpEvent details) {
    if (details.pointer == currentStroke.pointerId) {
      strokes = List.from(strokes)..add(currentStroke);
      currentStroke = Stroke();
      update();
    }
  }
}

class Stroke {
  final TransformLogic transformLogicModal = Get.find<TransformLogic>();

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
        transformLogicModal.transformToCanvasPoint(details.localPosition);
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
