import 'package:flutter/material.dart';
import 'package:flutter_application_2/modal/freedraw_logic.dart';
import 'package:flutter_application_2/modal/transform_logic.dart';
import 'package:get/get.dart';
import 'eraser_logic.dart';
import 'lasso_logic.dart';

enum ToolType {
  /// 自由绘画模式
  freeDraw,

  /// 平移或缩放画布模式
  transform,

  /// 橡皮擦模式
  eraser,

  /// 套索模式
  lasso,
}

class WhiteBoardBase extends GetxController {
  /// 当前选用工具类型（默认为平移缩放）
  ToolType currentToolType = ToolType.transform;

  final transformLogic = Get.find<TransformLogic>();
  final freeLogic = Get.find<FreeDrawLogic>();
  final eraserLogic = Get.find<EraserLogic>();
  final lassoLogic = Get.find<LassoLogic>();

  /// 手势按下触发逻辑
  onPointerDown(PointerDownEvent event) {
    switch (currentToolType) {
      case ToolType.transform:
        break;
      case ToolType.freeDraw:
        freeLogic.onPointerDown(event);
        break;
      case ToolType.eraser:
        eraserLogic.onPointerDown(event);
        break;
      case ToolType.lasso:
        lassoLogic.onPointerDown(event);
        break;
    }
  }

  /// 手势平移触发逻辑
  onPointerMove(PointerMoveEvent event) {
    switch (currentToolType) {
      case ToolType.transform:
        transformLogic.onPointerMove(event);
        break;
      case ToolType.freeDraw:
        freeLogic.onPointerMove(event);
        break;
      case ToolType.eraser:
        eraserLogic.onPointerMove(event);
        break;
      case ToolType.lasso:
        lassoLogic.onPointerMove(event);
        break;
    }
  }

  /// 手势提起触发逻辑
  onPointerUp(PointerUpEvent event) {
    switch (currentToolType) {
      case ToolType.transform:
        transformLogic.onPointerUp(event);
        break;
      case ToolType.freeDraw:
        freeLogic.onPointerUp(event);
        break;
      case ToolType.eraser:
        eraserLogic.onPointerUp(event);
        break;
      case ToolType.lasso:
        lassoLogic.onPointerUp(event);
        break;
    }
  }

  /// 缩放开始触发逻辑
  onScaleStart(ScaleStartDetails details) {
    switch (currentToolType) {
      case ToolType.transform:
        transformLogic.onScaleStart(details);
        break;
    }
  }

  /// 缩放中触发逻辑
  onScaleUpdate(ScaleUpdateDetails details) {
    switch (currentToolType) {
      case ToolType.transform:
        transformLogic.onScaleUpdate(details);
        break;
    }
  }

  /// 缩放结束触发逻辑
  onScaleEnd(ScaleEndDetails details) {
    switch (currentToolType) {
      case ToolType.transform:
        transformLogic.onScaleEnd(details);
        break;
    }
  }
}
