import 'package:flutter/material.dart';
import 'package:flutter_application_2/modal/board_modal.dart';
import '../utils/getElementOffsetByDrawing.dart';

extension EraserLogic on BoardModal {
  /// 手势按下触发逻辑
  execPointerDownForEraser(PointerDownEvent event) {
    currentEraserPosition = event.localPosition;
    erase(event.localPosition);
    update();
  }

  /// 手势移动触发逻辑
  execPointerMoveForEraser(PointerMoveEvent event) {
    currentEraserPosition = event.localPosition;
    erase(event.localPosition);
    update();
  }

  /// 手势抬起触发逻辑
  execPointerUpForEraser(PointerUpEvent event) {
    currentEraserPosition = null;
    update();
  }

  /// 橡皮擦擦除逻辑
  erase(Offset position) {
    if (currentEraserPosition == null) {
      return;
    }
    final tempPoint = getElementPointByDrawing(
        screenPoint: position,
        curCanvasOffset: curCanvasOffset,
        curCanvasScale: curCanvasScale);
    strokes.removeWhere((stroke) {
      return stroke.strokePoints.any((strokPoint) {
        final point = Offset(strokPoint.x, strokPoint.y);
        final distance = (tempPoint - point).distance; // 计算橡皮擦的位置和笔画的位置的距离
        return distance < eraserRadius;
      });
    });
    update();
  }
}
