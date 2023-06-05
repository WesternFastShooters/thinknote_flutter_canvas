import 'package:flutter/gestures.dart';
import 'package:flutter_application_2/model/store/canvas_store.dart';
import 'package:flutter_application_2/model/tool/eraser.dart';
import 'package:flutter_application_2/model/tool/hand.dart';
import 'package:flutter_application_2/model/tool/lasso.dart';
import 'package:flutter_application_2/model/tool/menu.dart';
import 'package:flutter_application_2/model/tool/pen.dart';
import 'package:get/get.dart';

class GraphicsCanvas extends GetxController
    with CanvasStore, Hand, Pen, Eraser, Lasso, Menu {
  switchTool(ActionType type) {
    resetEraser();
    resetPen();
    resetLasso();
    currentToolType = type;
    update();
  }

  clickMenuItem(MenuItemEnum mode) {
    switch (mode) {
      case MenuItemEnum.copy:
        copySelectedElement();
        switchLassoStep(LassoStep.drawLine);
        break;
      case MenuItemEnum.cut:
        cutSelectedElement();
        switchLassoStep(LassoStep.drawLine);
        break;
      case MenuItemEnum.delete:
        deleteSelectedElement();
        switchLassoStep(LassoStep.drawLine);
        break;
      case MenuItemEnum.paste:
        pasteSelectedElement(transformToCanvasOffset(triggerPosition));
        switchLassoStep(LassoStep.closeLine);
        break;
    }
    initMenu();
    update();
  }

  /// 手势按下触发逻辑
  onPointerDown(PointerDownEvent event) {
    switch (currentToolType) {
      case ActionType.freeDraw:
        onPenDown(event);
        break;
      case ActionType.eraser:
        onEraserDown(event);
        break;
      case ActionType.lasso:
        onLassoDown(event);
        onMenuDown(event);
        break;
    }
    update();
  }

  /// 手势平移触发逻辑
  onPointerMove(PointerMoveEvent event) {
    switch (currentToolType) {
      case ActionType.hand:
        onHandMove(event);
        break;
      case ActionType.freeDraw:
        onPenMove(event);
        break;
      case ActionType.eraser:
        onEraserMove(event);
        break;
      case ActionType.lasso:
        onLassoMove(event);
        break;
    }
    update();
  }

  /// 手势提起触发逻辑
  onPointerUp(PointerUpEvent event) {
    switch (currentToolType) {
      case ActionType.freeDraw:
        onPenUp(event);
        break;
      case ActionType.eraser:
        onEraserUp(event);
        break;
      case ActionType.lasso:
        onLassoUp(event);
        break;
    }
    update();
  }

  /// 缩放开始触发逻辑
  onScaleStart(ScaleStartDetails details) {
    switch (currentToolType) {
      case ActionType.hand:
        onHandScaleStart(details);
        break;
    }
    update();
  }

  /// 缩放中触发逻辑
  onScaleUpdate(ScaleUpdateDetails details) {
    switch (currentToolType) {
      case ActionType.hand:
        onHandScaleUpdate(details);
        break;
    }
    update();
  }

  /// 缩放结束触发逻辑
  onScaleEnd(ScaleEndDetails details) {
    switch (currentToolType) {
      case ActionType.hand:
        onHandScaleEnd(details);
        break;
    }
    update();
  }

  /// 双击触发逻辑
  onDoubleTapDown(TapDownDetails details) {
    switch (currentToolType) {
      case ActionType.lasso:
        onMenuDoubleTapDown(details);
        break;
    }
    update();
  }
}
