import 'package:flutter/cupertino.dart';
import '../white_board_manager.dart';

extension MenuGesture on WhiteBoardManager {
  /// 手势按下触发逻辑
  onMenuPointerDown(PointerDownEvent event) {
    if (whiteBoardModel.currentToolType == ActionType.lasso &&
        whiteBoardModel.isShowMenu) {
      whiteBoardModel.closeMenu();
    }
  }

  /// 双击触发逻辑
  onMenuDoubleTapDown(TapDownDetails details) {
    whiteBoardModel.currentMenuPosition = details.localPosition;
    if (whiteBoardModel.menuItems.isNotEmpty &&
        whiteBoardModel.currentToolType == ActionType.lasso) {
      whiteBoardModel.openMenu(currentMenuPosition: whiteBoardModel.currentMenuPosition);
    }
  }
}
