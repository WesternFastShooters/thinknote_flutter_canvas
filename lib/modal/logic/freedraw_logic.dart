import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/constants/tool_type.dart';
import 'package:flutter_application_2/modal/board_modal.dart';
import 'package:flutter_application_2/modal/stroke.dart';
import 'package:perfect_freehand/perfect_freehand.dart';

typedef StrokePoint = Point;

extension FreeDrawLogic on BoardModal {
  /// 自由绘画模式下，落笔触发逻辑
  void execPointerDownForFreeDraw(PointerDownEvent details) {
    if (currentToolType != ToolType.freeDraw) {
      return;
    }
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
  void execPointerMoveForFreeDraw(PointerMoveEvent details) {
    if (currentToolType != ToolType.freeDraw) {
      return;
    }
    if (details.pointer == currentStroke.pointerId) {
      currentStroke.storeStrokePoint(details);
      update();
    }
  }

  /// 自由绘画下，提笔触发逻辑
  void execPointerUpForFreeDraw(PointerUpEvent details) {
    if (currentToolType != ToolType.freeDraw) {
      return;
    }
    if (details.pointer == currentStroke.pointerId) {
      strokes = List.from(strokes)..add(currentStroke);
      currentStroke = Stroke();
      update();
    }
  }
}
