import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/constants/tool_type.dart';
import 'package:flutter_application_2/modal/board_modal.dart';
import 'package:flutter_application_2/modal/type/pencil_element_model.dart';
import 'package:flutter_application_2/modal/utils/getElementOffsetByDrawing.dart';
import 'package:flutter_application_2/modal/utils/getOffsetByScaleChange.dart';
import 'package:perfect_freehand/perfect_freehand.dart';

typedef StrokePoint = Point;

extension FreeDrawLogic on BoardModal {
  /// 自由绘画模式下，落笔触发逻辑
  void execPointerDownForFreeDraw(PointerDownEvent details) {
    if (currentToolType != ToolType.freeDraw) {
      return;
    }
    currentStrokeOptions = StrokeOptions(
      simulatePressure: details.kind != PointerDeviceKind.stylus,
    );
    final StrokePoint strokePoint = getStrokePoint(details);
    PencilElementModel pencilElementModel = PencilElementModel()
      ..strokePoints.add(strokePoint);
    drawingElementModelList.add(pencilElementModel);
    update();
  }

  /// 自由绘画下，移笔触发逻辑
  void execPointerMoveForFreeDraw(PointerMoveEvent details) {
    if (currentToolType != ToolType.freeDraw) {
      return;
    }
    final StrokePoint strokePoint = getStrokePoint(details);

    PencilElementModel pencilElementModel = drawingElementModelList.last
        as PencilElementModel
      ..strokePoints.add(strokePoint);
    update();
  }

  /// 自由绘画下，提笔触发逻辑
  void execPointerUpForFreeDraw(PointerUpEvent details) {
    if (currentToolType != ToolType.freeDraw) {
      return;
    }

    final StrokePoint strokePoint = getStrokePoint(details);

    PencilElementModel pencilElementModel = drawingElementModelList.last
        as PencilElementModel
      ..strokePoints.add(strokePoint);

    pencilElementModelList.add(pencilElementModel);
    drawingElementModelList.removeLast();
    update();
  }

  StrokePoint getStrokePoint(PointerEvent details) {
    final offsetStrokePoint = getElementPointByDrawing(
      screenPoint: details.localPosition,
      curCanvasOffset: curCanvasOffset,
      curCanvasScale: curCanvasScale,
    );

    final StrokePoint strokePoint = (() {
      if (details.kind == PointerDeviceKind.stylus) {
        return StrokePoint(
          offsetStrokePoint.dx,
          offsetStrokePoint.dy,
          (details.pressure - details.pressureMin) /
              (details.pressureMax - details.pressureMin),
        );
      } else {
        return StrokePoint(offsetStrokePoint.dx, offsetStrokePoint.dy);
      }
    })();

    return strokePoint;
  }
}
