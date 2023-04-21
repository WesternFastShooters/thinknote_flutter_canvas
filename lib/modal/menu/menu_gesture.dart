import 'package:flutter/cupertino.dart';
import 'package:flutter_application_2/modal/menu/menu_function.dart';
import '../white_board_manager.dart';

extension MenuGesture on WhiteBoardManager {
  /// 手势按下触发逻辑
  onMenuPointerDown(PointerDownEvent event) {
    if (whiteBoardConfig.currentToolType == ActionType.lasso &&
        whiteBoardConfig.isShowMenu) {
      closeMenu();
    }
  }

  /// 双击触发逻辑
  onMenuDoubleTapDown(TapDownDetails details) {
    whiteBoardConfig.currentMenuPosition = details.globalPosition;
    if (menuItems.isNotEmpty &&
        whiteBoardConfig.currentToolType == ActionType.lasso) {
      openMenu(currentMenuPosition: whiteBoardConfig.currentMenuPosition);
    }
  }
}
