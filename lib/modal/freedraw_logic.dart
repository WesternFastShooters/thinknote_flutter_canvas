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
  Rx<Stroke> currentStroke = (Stroke.init()).obs;

  /// 所有笔画
  RxList<Stroke> strokes = <Stroke>[].obs;

  /// 自由绘画模式下，落笔触发逻辑
  void onPointerDown(PointerDownEvent details) {
    currentStrokeOption = {
      ...currentStrokeOption,
      'simulatePressure': details.kind != PointerDeviceKind.stylus,
    };

    if (currentStroke.value.pointerId == -1) {
      currentStroke.update((Stroke? val) {
        val?.pointerId = details.pointer;
        val?.option = currentStrokeOption;
        val?.storeStrokePoint(details);
      });
    }
    update();
  }

  /// 自由绘画下，移笔触发逻辑
  void onPointerMove(PointerMoveEvent details) {
    if (details.pointer == currentStroke.value.pointerId) {
      currentStroke.update((val) {
        val?.storeStrokePoint(details);
      });
    }
    update();
  }

  /// 自由绘画下，提笔触发逻辑
  void onPointerUp(PointerUpEvent details) {
    if (details.pointer == currentStroke.value.pointerId) {
      strokes.add(Stroke(
        pointerId: currentStroke.value.pointerId,
        option: currentStroke.value.option,
      )..strokePoints = currentStroke.value.strokePoints);
      currentStroke.update((val) {
        val?.pointerId = -1;
        val?.option = null;
        val?.strokePoints = [];
      });
    }
    update();
  }
}

class Stroke {
  Stroke({
    required this.pointerId,
    required Map? option,
  }) {
    this.option = option;
  }
  factory Stroke.init() => Stroke(pointerId: -1, option: null);
  final TransformLogic transformLogicModal = Get.find<TransformLogic>();

  /// 笔画点集合
  List<StrokePoint> strokePoints = <StrokePoint>[]; // { dx,dy,pressure }[]

  /// 笔画id，用于区分不同的笔画，防止多个笔画同时绘制
  int pointerId = -1;

  /// 笔画配置属性
  Map _option = {
    'size': 3.0.obs,
    'thinning': 0.1.obs,
    'smoothing': 0.5.obs,
    'streamline': 0.5.obs,
    'taperStart': 0.0.obs,
    'capStart': true.obs,
    'taperEnd': 0.1.obs,
    'capEnd': true.obs,
    'simulatePressure': true.obs,
    'isComplete': false.obs,
    'color': Colors.pink.obs,
  };
  set option(Map? option) => _option = option ?? _option;
  Map get option => _option;

  Path? get path {
    final tempPath = Path();
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
      isComplete: false,
    );
    if (outlinePoints.isEmpty) {
      return null;
    } else if (outlinePoints.length < 2) {
      tempPath.addOval(Rect.fromCircle(
          center: Offset(outlinePoints[0].x, outlinePoints[0].y), radius: 1));
    } else {
      tempPath.moveTo(outlinePoints[0].x, outlinePoints[0].y);

      for (int i = 1; i < outlinePoints.length - 1; ++i) {
        final p0 = outlinePoints[i];
        final p1 = outlinePoints[i + 1];
        tempPath.quadraticBezierTo(
            p0.x, p0.y, (p0.x + p1.x) / 2, (p0.y + p1.y) / 2);
      }
    }
    return tempPath;
  }

  // Paint get paint => Paint()..color = option['color'];
  // 转为响应式
  Paint get paint => Paint()..color = option['color'];

  /// 判断笔画是否为空
  bool get isEmpty => strokePoints.isEmpty;

  /// 存储笔画点
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
