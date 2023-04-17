import 'package:flutter/gestures.dart';
import 'package:flutter_application_2/modal/eraser/eraser_gesture.dart';
import 'package:flutter_application_2/modal/freedraw/freedraw_gesture.dart';
import 'package:flutter_application_2/modal/lasso/lasso_gesture.dart';
import 'package:flutter_application_2/modal/menu/menu_gesture.dart';
import 'package:flutter_application_2/modal/transform/transform_gesture.dart';
import 'package:flutter_application_2/modal/white_board_manager.dart';

extension GestureLogic on WhiteBoardConfig {
  /// 手势按下触发逻辑
  onPointerDown(PointerDownEvent event) {
    switch (currentToolType) {
      case ActionType.freeDraw:
        onFreeDrawPointerDown(event);
        break;
      case ActionType.eraser:
        onEraserPointerDown(event);
        break;
      case ActionType.lasso:
        onLassoPointerDown(event);
        onMenuPointerDown(event);
        break;
    }
  }

  /// 手势平移触发逻辑
  onPointerMove(PointerMoveEvent event) {
    switch (currentToolType) {
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
    switch (currentToolType) {
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
  }

  /// 双击触发逻辑
  onDoubleTapDown(TapDownDetails details) {
    switch (currentToolType) {
      case ActionType.lasso:
        onMenuDoubleTapDown(details);
        break;
    }
  }
}
