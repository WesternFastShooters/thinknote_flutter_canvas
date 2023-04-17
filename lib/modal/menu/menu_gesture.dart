import 'package:flutter/cupertino.dart';
import 'package:flutter_application_2/modal/menu/menu_function.dart';
import '../white_board_manager.dart';

extension MenuGesture on WhiteBoardConfig {
  /// 手势按下触发逻辑
  onMenuPointerDown(PointerDownEvent event) {
    closeMenu();
  }

  /// 双击触发逻辑
  onMenuDoubleTapDown(TapDownDetails details) {
    currentMenuPosition = details.localPosition;
    if (menuItems.isNotEmpty) {
        openMenu(
            currentMenuPosition: currentMenuPosition);
      }
  }
}
