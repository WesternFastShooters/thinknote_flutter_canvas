import 'dart:ui' as ui;
import 'package:flutter/gestures.dart';
import 'package:flutter_application_2/modal/common_utils.dart';
import 'package:flutter_application_2/modal/white_board_manager.dart';
import 'package:flutter_application_2/modal/transform_logic.dart';
import 'package:flutter_application_2/type/elementType/stroke_type.dart';

extension EraserLogic on WhiteBoardManager {
  onEraserPointerDown(PointerDownEvent details) {
    if (eraserConfig.currentEraserPosition == null && currentPointerId == -1) {
      eraserConfig.currentEraserPosition =
          transformToCanvasPoint(details.position);
      erase();
      currentPointerId = details.pointer;
      update();
    }
  }

  onEraserPointerMove(PointerMoveEvent details) {
    if (details.pointer == currentPointerId) {
      eraserConfig.currentEraserPosition =
          transformToCanvasPoint(details.position);
      erase();
      update();
    }
  }

  onEraserPointerUp(PointerUpEvent details) {
    if (details.pointer == currentPointerId) {
      eraserConfig.currentEraserPosition = null;
      currentPointerId = -1;
      update();
    }
  }

  /// 擦除
  erase() {
    if (eraserConfig.currentEraserPosition == null) return;
    final eraserPath = eraserConfig.eraserPath;

    canvasElementList.removeWhere((item) {
      return isIntersecting(
          originPath: eraserPath, targetPath: (item.element as Stroke).path);
    });
    update();
  }
}
