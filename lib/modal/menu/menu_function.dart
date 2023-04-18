import 'dart:ui';

import 'package:flutter_application_2/modal/lasso/lasso_function.dart';
import 'package:flutter_application_2/modal/utils/geometry_tool.dart';
import '../../type/elementType/whiteboard_element.dart';
import '../white_board_manager.dart';
import 'menu_config.dart';

extension MenuFuction on WhiteBoardConfig {
  /// 打开菜单
  openMenu({
    required Offset currentMenuPosition,
  }) {
    if (menuItems.isNotEmpty) {
      this.currentMenuPosition = currentMenuPosition;
      isShowMenu = true;
      this.menuItems = menuItems;
    }
  }

  /// 关闭菜单
  closeMenu() {
    isShowMenu = false;
    currentMenuPosition = Offset.zero;
  }

  /// 重置菜单配置
  resetMenuConfig() {
    currentMenuPosition = Offset.zero;
    isShowMenu = false;
    lastSelectItem = MenuItemEnum.none;
    lastMenuCopyOrCutPosition = Offset.zero;
  }

  /// 处理点击菜单项
  clickMenuItem( MenuItemEnum currentSelectItem) {
    isShowMenu = false;
    switch (currentSelectItem) {
      case MenuItemEnum.copy:
        copiedElementList =
            selectedElementList.map((e) => e.deepCopy()).toList();
        copiedElementCenterPoint = getSelectedElementCenter(
          copiedElementList.map((e) => e.path).toList(),
        );
        lastSelectItem = currentSelectItem;
        break;
      case MenuItemEnum.cut:
        copiedElementList =
            selectedElementList.map((e) => e.deepCopy()).toList();
        copiedElementCenterPoint = getSelectedElementCenter(
          copiedElementList.map((e) => e.path).toList(),
        );
        canvasElementList.removeWhere((canvasElementItem) =>
            selectedElementList.any((selectedElementItem) =>
                identical(canvasElementItem, selectedElementItem)));
        lastSelectItem = currentSelectItem;
        break;
      case MenuItemEnum.paste:
        if (lastSelectItem == MenuItemEnum.copy ||
            lastSelectItem == MenuItemEnum.cut) {
          for (var item in copiedElementList) {
            item.translateElement(
                offset: (currentMenuPosition - copiedElementCenterPoint),
                mode: MoveElementMode.teleport);
          }
          canvasElementList = [...canvasElementList, ...copiedElementList];
        }
        lastSelectItem = currentSelectItem;
        break;
      case MenuItemEnum.delete:
        canvasElementList.removeWhere((canvasElementItem) =>
            selectedElementList.any((selectedElementItem) =>
                identical(canvasElementItem, selectedElementItem)));
        lastSelectItem = currentSelectItem;
        break;
    }
    resetLassoConfig();
  }

  /// 获取菜单项
  List<MenuItemEnum> get menuItems {
    final pasteItem = copiedElementList.isNotEmpty ? [MenuItemEnum.paste] : [];
    final canOperate = isHitLassoCloseArea(transformToCanvasPoint(
              currentMenuPosition,
            )) &&
            selectedElementList.isNotEmpty
        ? [MenuItemEnum.copy, MenuItemEnum.cut, MenuItemEnum.delete]
        : [];
    return [...canOperate, ...pasteItem];
  }
}
