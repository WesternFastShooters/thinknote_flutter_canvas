import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter_application_2/modal/common_utils.dart';
import 'package:flutter_application_2/modal/white_board_manager.dart';
import 'package:flutter_application_2/type/configType/lasso_config.dart';

extension MenuLogic on WhiteBoardManager {
  /// 手势按下触发逻辑
  onMenuPointerDown(PointerDownEvent event) {
    switch (currentToolType.value) {
      case ActionType.transform:
        if (menuConfig.isShowMenu) {
          menuConfig.reset();
          update();
        }
        break;
      case ActionType.lasso:
        if (menuConfig.isShowMenu) {
          menuConfig.reset();
          update();
        }
        break;
    }
  }

  /// 长按开始触发逻辑
  onLongPressStart(LongPressStartDetails details) {
    // 长按使菜单出现
    switch (currentToolType.value) {
      case ActionType.transform:
        if (selectedElementList.isNotEmpty) {
          menuConfig.showMenu(
              menuPosition: details.localPosition,
              isShowMenu: true,
              menuItems: ['粘贴']);
          update();
        }
        break;
      case ActionType.lasso:
        if (lassoConfig.lassoStep == LassoStep.close &&
            lassoConfig.isHitLassoCloseArea(
                transformToCanvasPoint(details.localPosition)) &&
            selectedElementList.isNotEmpty) {
          menuConfig.showMenu(
              menuPosition: details.localPosition,
              isShowMenu: true,
              menuItems: ['复制', '剪切', '删除', '粘贴']);
          update();
        }
        break;
    }
  }

  /// 执行复制操作
  copyElement() {
    print('执行复制操作');
  }

  /// 执行剪切操作
  cutElement() {
    print('执行剪切操作');
  }

  /// 执行删除操作
  deleteElement() {
    print('执行删除操作');
  }

  /// 执行粘贴操作
  pasteElement() {
    print('执行粘贴操作');
  }
}
