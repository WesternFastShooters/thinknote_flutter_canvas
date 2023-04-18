import 'package:flutter/gestures.dart';
import 'package:flutter_application_2/modal/eraser/eraser_config.dart';
import 'package:flutter_application_2/modal/eraser/eraser_function.dart';
import 'package:flutter_application_2/modal/freedraw/freedraw_config.dart';
import 'package:flutter_application_2/modal/freedraw/freedraw_function.dart';
import 'package:flutter_application_2/modal/gesture/gesture_logic.dart';
import 'package:flutter_application_2/modal/lasso/lasso_config.dart';
import 'package:flutter_application_2/modal/lasso/lasso_function.dart';
import 'package:flutter_application_2/modal/menu/menu_config.dart';
import 'package:flutter_application_2/modal/transform/transform_config.dart';
import 'package:get/get.dart';

import '../type/elementType/whiteboard_element.dart';

enum ActionType {
  /// 自由绘画模式
  freeDraw,

  /// 平移或缩放画布模式
  transform,

  /// 橡皮擦模式
  eraser,

  /// 套索模式
  lasso,

  /// 拖拽模式
  drag,
}

class WhiteBoardManager extends GetxController {
  WhiteBoardConfig whiteBoardConfig = WhiteBoardConfig();

  /// 切换当前工具
  setCurrentToolType(ActionType type) {
    whiteBoardConfig.currentToolType = type;
    whiteBoardConfig.onSwitchCurrentToolType();
    update();
  }
}

extension GestureLogic on WhiteBoardManager {
  /// 手势按下触发逻辑
  onPointerDown(PointerDownEvent event) {
    whiteBoardConfig.onPointerDown(event);
    update();
  }

  /// 手势平移触发逻辑
  onPointerMove(PointerMoveEvent event) {
    whiteBoardConfig.onPointerMove(event);
    update();
  }

  /// 手势提起触发逻辑
  onPointerUp(PointerUpEvent event) {
    whiteBoardConfig.onPointerUp(event);
    update();
  }

  /// 缩放开始触发逻辑
  onScaleStart(ScaleStartDetails details) {
    whiteBoardConfig.onScaleStart(details);
    update();
  }

  /// 缩放中触发逻辑
  onScaleUpdate(ScaleUpdateDetails details) {
    whiteBoardConfig.onScaleUpdate(details);
    update();
  }

  /// 缩放结束触发逻辑
  onScaleEnd(ScaleEndDetails details) {
    whiteBoardConfig.onScaleEnd(details);
    update();
  }

  /// 双击触发逻辑
  onDoubleTapDown(TapDownDetails details) {
    whiteBoardConfig.onDoubleTapDown(details);
    update();
  }
}

class WhiteBoardConfig
    with
        EraserConfig,
        FreedrawConfig,
        LassoConfig,
        MenuConfig,
        TransformConfig {
  WhiteBoardConfig();

  /// 当前选用工具类型（默认为平移缩放）
  ActionType currentToolType = ActionType.transform;

  /// 切换当前工具触发逻辑
  onSwitchCurrentToolType() {
    resetEraserConfig();
    resetFreeDraw();
    resetLassoConfig();
  }

  /// 存储已经绘制完成的canvas元素列表
  List<WhiteBoardElement> canvasElementList = [];
}
