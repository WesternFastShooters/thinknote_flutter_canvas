import 'package:flutter/gestures.dart';
import 'package:flutter_application_2/modal/transform_logic.dart';
import 'package:get/get.dart';

class LassoLogic extends GetxController {
  final TransformLogic transformLogicModal = Get.find<TransformLogic>();

  /// 绘制套索虚线路径
  RxList<Offset> currentLassoPoints = RxList<Offset>([]);

  /// 套索闭合路径
  RxList<Offset> closedShapePolygonPoints = RxList<Offset>([]);


  /// 手势按下触发逻辑
  onPointerDown(PointerDownEvent event) {
    currentLassoPoints
        .add(transformLogicModal.transformToCanvasPoint(event.localPosition));
    update();
  }

  /// 手势移动触发逻辑
  onPointerMove(PointerMoveEvent event) {
    currentLassoPoints
        .add(transformLogicModal.transformToCanvasPoint(event.localPosition));
    update();
  }

  /// 手势抬起触发逻辑
  onPointerUp(PointerUpEvent event) {
    closedShapePolygonPoints.addAll(currentLassoPoints);
    currentLassoPoints.clear();
    update();
  }
}
