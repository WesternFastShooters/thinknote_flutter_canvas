import 'dart:ui';

import 'package:flutter_application_2/modal/lasso/lasso_function.dart';
import 'package:flutter_application_2/modal/utils/geometry_tool.dart';
import '../../type/elementType/whiteboard_element.dart';
import '../white_board_manager.dart';
import 'menu_config.dart';

extension MenuFuction on WhiteBoardManager {
  /// 打开菜单
  openMenu({
    required Offset currentMenuPosition,
  }) {
    if (menuItems.isNotEmpty) {
      whiteBoardConfig.currentMenuPosition = currentMenuPosition;
      whiteBoardConfig.isShowMenu = true;
      whiteBoardConfig.menuItems = menuItems;
    }
  }

  /// 关闭菜单
  closeMenu() {
    whiteBoardConfig.isShowMenu = false;
    whiteBoardConfig.currentMenuPosition = Offset.zero;
  }

  /// 重置菜单配置
  resetMenuConfig() {
    whiteBoardConfig.currentMenuPosition = Offset.zero;
    whiteBoardConfig.isShowMenu = false;
    whiteBoardConfig.lastSelectItem = MenuItemEnum.none;
    whiteBoardConfig.lastMenuCopyOrCutPosition = Offset.zero;
  }

  /// 处理点击菜单项
  clickMenuItem(MenuItemEnum currentSelectItem) {
    whiteBoardConfig.isShowMenu = false;
    switch (currentSelectItem) {
      case MenuItemEnum.copy:
        whiteBoardConfig.copiedElementList = whiteBoardConfig
            .selectedElementList
            .map((e) => e.deepCopy())
            .toList();
        whiteBoardConfig.copiedElementCenterPoint = getSelectedElementCenter(
          whiteBoardConfig.copiedElementList.map((e) => e.path).toList(),
        );
        whiteBoardConfig.lastSelectItem = currentSelectItem;
        break;
      case MenuItemEnum.cut:
        whiteBoardConfig.copiedElementList = whiteBoardConfig
            .selectedElementList
            .map((e) => e.deepCopy())
            .toList();
        whiteBoardConfig.copiedElementCenterPoint = getSelectedElementCenter(
          whiteBoardConfig.copiedElementList.map((e) => e.path).toList(),
        );
        whiteBoardConfig.canvasElementList.removeWhere((canvasElementItem) =>
            whiteBoardConfig.selectedElementList.any((selectedElementItem) =>
                identical(canvasElementItem, selectedElementItem)));
        whiteBoardConfig.lastSelectItem = currentSelectItem;
        break;
      case MenuItemEnum.paste:
        if (whiteBoardConfig.lastSelectItem == MenuItemEnum.copy ||
            whiteBoardConfig.lastSelectItem == MenuItemEnum.cut) {
          for (var item in whiteBoardConfig.copiedElementList) {
            item.translateElement(
              (whiteBoardConfig.currentMenuPosition -
                  whiteBoardConfig.copiedElementCenterPoint),
            );
          }
          whiteBoardConfig.canvasElementList = [
            ...whiteBoardConfig.canvasElementList,
            ...whiteBoardConfig.copiedElementList
          ];
        }
        whiteBoardConfig.lastSelectItem = currentSelectItem;
        break;
      case MenuItemEnum.delete:
        whiteBoardConfig.canvasElementList.removeWhere((canvasElementItem) =>
            whiteBoardConfig.selectedElementList.any((selectedElementItem) =>
                identical(canvasElementItem, selectedElementItem)));
        whiteBoardConfig.lastSelectItem = currentSelectItem;
        break;
    }
    resetLassoConfig();
    update();
  }

  /// 获取菜单项
  List<MenuItemEnum> get menuItems {
    final pasteItem = whiteBoardConfig.copiedElementList.isNotEmpty
        ? [MenuItemEnum.paste]
        : [];
    final canOperate = isHitLassoCloseArea(transformToCanvasPoint(
              whiteBoardConfig.currentMenuPosition,
            )) &&
            whiteBoardConfig.selectedElementList.isNotEmpty
        ? [MenuItemEnum.copy, MenuItemEnum.cut, MenuItemEnum.delete]
        : [];
    return [...canOperate, ...pasteItem];
  }
}
