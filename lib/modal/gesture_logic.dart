import 'package:flutter/gestures.dart';
import 'package:flutter_application_2/modal/eraser_logic.dart';
import 'package:flutter_application_2/modal/freedraw_logic.dart';
import 'package:flutter_application_2/modal/lasso_logic.dart';
import 'package:flutter_application_2/modal/transform_logic.dart';
import 'package:flutter_application_2/modal/white_board_manager.dart';

extension GestureLogic on WhiteBoardManager {
  /// 手势按下触发逻辑
  onPointerDown(PointerDownEvent event) {
    if (currentPointerId != -1) {
      return;
    }
    currentPointerId = event.pointer;
    switch (currentToolType.value) {
      case ActionType.transform:
        break;
      case ActionType.freeDraw:
        onFreeDrawPointerDown(event);
        break;
      case ActionType.eraser:
        onEraserPointerDown(event);
        break;
      case ActionType.lasso:
        onLassoPointerDown(event);
        break;
    }
  }

  /// 手势平移触发逻辑
  onPointerMove(PointerMoveEvent event) {
    if (event.pointer != currentPointerId) {
      return;
    }
    switch (currentToolType.value) {
      case ActionType.transform:
        onTranslatePointerMove(event);
        break;
      case ActionType.freeDraw:
        onFreeDrawPointerMove(event);
        break;
      case ActionType.eraser:
        onEraserPointerMove(event);
        break;
      case ActionType.lasso:
        onLassoPointerMove(event);
        break;
    }
  }

  /// 手势提起触发逻辑
  onPointerUp(PointerUpEvent event) {
    if (event.pointer != currentPointerId) {
      return;
    }
    currentPointerId = -1;
    switch (currentToolType.value) {
      case ActionType.transform:
        onTranslatePointerUp(event);
        break;
      case ActionType.freeDraw:
        onFreeDrawPointerUp(event);
        break;
      case ActionType.eraser:
        onEraserPointerUp(event);
        break;
      case ActionType.lasso:
        onLassoPointerUp(event);
        break;
    }
    update();
  }
}
