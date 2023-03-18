import 'package:flutter_application_2/constants/tool_type.dart';
import 'package:flutter_application_2/modal/logic/area_logic.dart';
import 'package:flutter_application_2/modal/logic/eraser_logic.dart';
import 'package:flutter_application_2/modal/logic/freedraw_logic.dart';
import 'package:flutter_application_2/modal/type/pencil_element_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class BoardModal extends GetxController {
  /// 当前选用工具类型（默认为平移缩放）
  ToolType currentToolType = ToolType.translateAndScaleCanvas;

  /// 画布当前的偏移量
  Offset curCanvasOffset = Offset.zero;

  /// 可视区域的大小
  Size visibleAreaSize = Size.zero;

  /// 可视区域的中心
  Offset visibleAreaCenter = Offset.zero;

  /// 用来计算双指缩放是缩小还是放大
  ScaleUpdateDetails? lastScaleUpdateDetails;

  /// 画布当前的缩放比例
  double curCanvasScale = 1.0;

  /// 画布上一次的缩放比例
  double preCanvasScale = 1.0;

  /// 最小缩放
  final double minCanvasScale = 0.1;

  /// 最大缩放
  final double maxCanvasScale = 3.0;

  /// 当前笔画的配置属性
  StrokeOptions currentStrokeOptions = StrokeOptions();

  /// 所有笔画
  List<Stroke> strokes = <Stroke>[];

  /// 当前笔画
  Stroke currentStroke = Stroke(strokePoints: [], pointerId: 0);

  /// 当前橡皮擦的位置
  Offset? currentEraserPosition;

  /// 橡皮擦半径
  double eraserRadius = 10.0;
}

extension BaseAction on BoardModal {
  /// 手势按下触发逻辑
  onPointerDown(PointerDownEvent event) {
    switch (currentToolType) {
      case ToolType.translateAndScaleCanvas:
        break;
      case ToolType.freeDraw:
        execPointerDownForFreeDraw(event);
        break;
      case ToolType.eraser:
        execPointerDownForEraser(event);
        break;
    }
  }

  /// 手势平移触发逻辑
  onPointerMove(PointerMoveEvent event) {
    switch (currentToolType) {
      case ToolType.translateAndScaleCanvas:
        execPointerMoveForTranslate(event);
        break;
      case ToolType.freeDraw:
        execPointerMoveForFreeDraw(event);
        break;
      case ToolType.eraser:
        execPointerMoveForEraser(event);
        break;
    }
  }

  /// 手势提起触发逻辑
  onPointerUp(PointerUpEvent event) {
    switch (currentToolType) {
      case ToolType.translateAndScaleCanvas:
        execPointerUpForTranslate(event);
        break;
      case ToolType.freeDraw:
        execPointerUpForFreeDraw(event);
        break;
      case ToolType.eraser:
        execPointerUpForEraser(event);
        break;
    }
  }

  /// 缩放开始触发逻辑
  onScaleStart(ScaleStartDetails details) {
    switch (currentToolType) {
      case ToolType.translateAndScaleCanvas:
        onScaleStartForArea(details);
        break;
      case ToolType.freeDraw:
        break;
    }
  }

  /// 缩放中触发逻辑
  onScaleUpdate(ScaleUpdateDetails details) {
    switch (currentToolType) {
      case ToolType.translateAndScaleCanvas:
        onScaleUpdateForArea(details);
        break;
      case ToolType.freeDraw:
        break;
    }
  }

  /// 缩放结束触发逻辑
  onScaleEnd(ScaleEndDetails details) {
    switch (currentToolType) {
      case ToolType.translateAndScaleCanvas:
        onScaleEndForArea(details);
        break;
      case ToolType.freeDraw:
        break;
    }
  }
}
