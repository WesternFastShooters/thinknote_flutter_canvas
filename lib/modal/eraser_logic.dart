import 'package:flutter/gestures.dart';
import 'package:flutter_application_2/modal/freedraw_logic.dart';
import 'package:flutter_application_2/modal/transform_logic.dart';
import 'package:get/get.dart';

class EraserLogic extends GetxController {
  final TransformLogic transformLogicModal = Get.find<TransformLogic>();
  final FreeDrawLogic freeDrawLogic = Get.find<FreeDrawLogic>();

  /// 当前橡皮擦的位置
  Offset? _currentEraserPosition;
  Offset? get currentEraserPosition => _currentEraserPosition;
  set currentEraserPosition(Offset? position) {
    _currentEraserPosition = position != null
        ? transformLogicModal.transformToCanvasPoint(position)
        : position;
    update();
  }

  /// 橡皮擦半径
  double eraserRadius = 10.0;


  /// 手势按下触发逻辑
  onPointerDown(PointerDownEvent event) {
    erase(event.localPosition);
    update();
  }

  /// 手势移动触发逻辑
  onPointerMove(PointerMoveEvent event) {
    erase(event.localPosition);
    update();
  }

  /// 手势抬起触发逻辑
  onPointerUp(PointerUpEvent event) {
    currentEraserPosition = null;
    update();
  }

  /// 橡皮擦擦除逻辑
  erase(Offset position) {
    currentEraserPosition = position;
    if (currentEraserPosition == null) {
      return;
    }
    freeDrawLogic.strokes.removeWhere((stroke) {
      return stroke.strokePoints.any((strokPoint) {
        final point = Offset(strokPoint.x, strokPoint.y);
        final distance =
            (currentEraserPosition! - point).distance; // 计算橡皮擦的位置和笔画的位置的距离
        return distance < eraserRadius;
      });
    });
    update();
  }
}
