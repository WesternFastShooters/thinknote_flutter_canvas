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
    onSwitchCurrentToolType();
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

  /// 存储已经绘制完成的canvas元素列表
  List<WhiteBoardElement> canvasElementList = [];
}
