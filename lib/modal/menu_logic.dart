import 'package:flutter/gestures.dart';
import 'package:flutter_application_2/modal/common_utils.dart';
import 'package:flutter_application_2/modal/white_board_manager.dart';
import 'package:flutter_application_2/type/configType/menu_config.dart';
import 'package:flutter_application_2/type/elementType/element_container.dart';
import 'package:flutter_application_2/type/elementType/white_element.dart';

extension MenuLogic on WhiteBoardManager {
  /// 手势按下触发逻辑
  onMenuPointerDown(PointerDownEvent event) {
    if (currentToolType.value == ActionType.transform ||
        currentToolType.value == ActionType.lasso) {
      menuConfig.isShowMenu = false;
      update();
    }
  }

  /// 双击触发逻辑
  onDoubleTapDown(TapDownDetails details) {
    menuConfig.currentMenuPosition = details.localPosition;
    if (currentToolType.value == ActionType.transform ||
        currentToolType.value == ActionType.lasso) {
      final menuItems = getMenuItems();
      if (menuItems.isNotEmpty) {
        menuConfig.openMenu(
            currentMenuPosition: menuConfig.currentMenuPosition,
            menuItems: menuItems);
        update();
      }
    }
  }

  /// 获取菜单项
  List<MenuItemEnum> getMenuItems() {
    final pasteItem = copiedElementList.isNotEmpty ? [MenuItemEnum.paste] : [];
    final canOperate = lassoConfig.isHitLassoCloseArea(
                transformToCanvasPoint(menuConfig.currentMenuPosition)) &&
            selectedElementList.isNotEmpty
        ? [MenuItemEnum.copy, MenuItemEnum.cut, MenuItemEnum.delete]
        : [];
    return [...canOperate, ...pasteItem];
  }

  /// 执行复制操作
  copyElement() {
    menuConfig.latestSelectItem = MenuItemEnum.copy;
    menuConfig.lastMenuPosition = menuConfig.currentMenuPosition;
    menuConfig.isShowMenu = false;
    copiedElementList = selectedElementList.map((e) => e.deepCopy()).toList();
    lassoConfig.reset();
    selectedElementList.clear;
    update();
  }

  /// 执行剪切操作
  cutElement() {
    menuConfig.latestSelectItem = MenuItemEnum.cut;
    menuConfig.lastMenuPosition = menuConfig.currentMenuPosition;
    menuConfig.isShowMenu = false;
    copiedElementList = selectedElementList.map((e) => e.deepCopy()).toList();
    canvasElementList.removeWhere((canvasElementItem) =>
        selectedElementList.any((selectedElementItem) =>
            identical(canvasElementItem, selectedElementItem)));
    lassoConfig.reset();
    selectedElementList.clear;
    update();
  }

  /// 执行粘贴操作
  pasteElement() {
    menuConfig.latestSelectItem = MenuItemEnum.paste;
    Offset delta = menuConfig.currentMenuPosition - menuConfig.lastMenuPosition;
    menuConfig.isShowMenu = false;
    switch (menuConfig.latestSelectItem) {
      case MenuItemEnum.copy:
        canvasElementList = {...canvasElementList, ...copiedElementList}
            as List<ElementContainer<WhiteElement>>;
        copiedElementList.clear();
        break;
      case MenuItemEnum.cut:
        for (var item in copiedElementList) {
          item.element.setDragOffset(delta);
        }
        canvasElementList = {...canvasElementList, ...copiedElementList}
            as List<ElementContainer<WhiteElement>>;
        copiedElementList.clear();
        break;
    }
    menuConfig.reset();
    lassoConfig.reset();
    update();
  }

  /// 执行删除操作
  deleteElement() {
    menuConfig.latestSelectItem = MenuItemEnum.delete;
    Offset delta = menuConfig.currentMenuPosition - menuConfig.lastMenuPosition;
    menuConfig.isShowMenu = false;
    canvasElementList.removeWhere((canvasElementItem) =>
        selectedElementList.any((selectedElementItem) =>
            identical(canvasElementItem, selectedElementItem)));
    selectedElementList.clear();
    menuConfig.reset();
    lassoConfig.reset();
    update();
  }
}
