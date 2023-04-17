import 'dart:ui';

import 'package:flutter_application_2/modal/utils/geometry_tool.dart';

import '../../type/elementType/element_container.dart';
import '../../type/elementType/white_element.dart';
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

  /// 处理点击菜单项
  clickMenuItem({required MenuItemEnum currentSelectItem}) {
    isShowMenu = false;
    switch (currentSelectItem) {
      case MenuItemEnum.copy:
        lastMenuCopyOrCutPosition = currentMenuPosition;
        lastSelectItem = currentSelectItem;
        copiedElementList =
            selectedElementList.map((e) => e.deepCopy()).toList();
        break;
      case MenuItemEnum.cut:
        lastMenuCopyOrCutPosition = currentMenuPosition;
        lastSelectItem = currentSelectItem;
        copiedElementList =
            selectedElementList.map((e) => e.deepCopy()).toList();
        canvasElementList.removeWhere((canvasElementItem) =>
            selectedElementList.any((selectedElementItem) =>
                identical(canvasElementItem, selectedElementItem)));
        break;
      case MenuItemEnum.paste:
        Offset delta = currentMenuPosition - lastMenuCopyOrCutPosition;
        switch (lastSelectItem) {
          case MenuItemEnum.copy:
            canvasElementList = {...canvasElementList, ...copiedElementList}
                as List<ElementContainer<WhiteElement>>;
            break;
          case MenuItemEnum.cut:
            for (var item in copiedElementList) {
              item.element.setDragOffset(delta);
            }
            canvasElementList = {...canvasElementList, ...copiedElementList}
                as List<ElementContainer<WhiteElement>>;
            break;
        }
        lastSelectItem = currentSelectItem;
        break;
      case MenuItemEnum.delete:
        lastSelectItem = currentSelectItem;
        canvasElementList.removeWhere((canvasElementItem) =>
            selectedElementList.any((selectedElementItem) =>
                identical(canvasElementItem, selectedElementItem)));
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
