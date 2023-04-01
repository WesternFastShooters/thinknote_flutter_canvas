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
      currentStroke = (Stroke(
        pointerId: details.pointer,
        option: currentStrokeOption,
      )..storeStrokePoint(details))
          .obs;
    }
    update();
  }

  /// 自由绘画下，移笔触发逻辑
  void onPointerMove(PointerMoveEvent details) {
    if (details.pointer == currentStroke.value.pointerId) {
      currentStroke.value.storeStrokePoint(details);
    }
    update();
  }

  /// 自由绘画下，提笔触发逻辑
  void onPointerUp(PointerUpEvent details) {
    if (details.pointer == currentStroke.value.pointerId) {
      strokes = RxList(List.from(strokes.value)..add(currentStroke.value));
      currentStroke = (Stroke.init()).obs;
    }
    update();
  }
}

class Stroke extends GetxController {
  Stroke({
    required this.pointerId,
    required Map? option,
  }) {
    this.option = RxMap(option ?? {...this.option});
  }
  factory Stroke.init() => Stroke(pointerId: -1, option: null);
  final TransformLogic transformLogicModal = Get.find<TransformLogic>();
  /// 笔画点集合
  RxList<StrokePoint> strokePoints = <StrokePoint>[].obs; // { dx,dy,pressure }[]

  /// 笔画id，用于区分不同的笔画，防止多个笔画同时绘制
  int pointerId = -1;

  /// 笔画配置属性
  Map option = {
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

  /// 笔画路径
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
    update();
  }
}
