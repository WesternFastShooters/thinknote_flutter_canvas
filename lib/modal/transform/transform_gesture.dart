import 'package:flutter/gestures.dart';
import 'package:flutter_application_2/modal/transform/transform_function.dart';
import 'package:flutter_application_2/modal/white_board_manager.dart';

extension TransformGesture on WhiteBoardConfig {
  /// 平移时移动执行回调
  onTransformPointerMove(PointerMoveEvent event) {
    globalCanvasOffset += event.localDelta;
  }

  /// 缩放开始执行回调
  onTransformScaleStart(ScaleStartDetails detail) {
    if (currentToolType != ActionType.transform) return;
    if (detail.pointerCount >= 2) {
      lastScaleUpdateDetails = null;
    }
  }

  /// 缩放中执行回调
  onTransformScaleUpdate(ScaleUpdateDetails detail) {
    if (currentToolType != ActionType.transform) return;
    if (detail.pointerCount >= 2) {
      executeTranslating(detail);
      executeScaling(detail);
    }
  }

  /// 缩放结束执行回调
  onTransformScaleEnd(ScaleEndDetails details) {
    if (currentToolType != ActionType.transform) return;
    if (details.pointerCount >= 2) {
      lastScaleUpdateDetails = null;
    }
  }
}
