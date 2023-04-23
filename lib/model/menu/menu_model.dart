import 'dart:ui';
import 'package:flutter_application_2/model/lasso/lasso_model.dart';
import 'package:flutter_application_2/type/elementType/whiteboard_element.dart';

enum MenuItemEnum {
  copy,
  delete,
  paste,
  cut,
  none,
}

extension MenuItemEnumExtension on MenuItemEnum {
  String get value {
    switch (this) {
      case MenuItemEnum.copy:
        return '复制';
      case MenuItemEnum.delete:
        return '删除';
      case MenuItemEnum.paste:
        return '粘贴';
      case MenuItemEnum.cut:
        return '剪切';
      case MenuItemEnum.none:
        return '无';
    }
  }
}

mixin MenuModel on LassoModel {
  /// 是否展示菜单
  bool isShowMenu = false;

  /// 当前菜单展开位置
  Offset currentMenuPosition = Offset.zero;

  /// 上一次复制或者粘贴的位置
  Offset lastMenuCopyOrCutPosition = Offset.zero;

  /// 存储选中的元素
  List<WhiteBoardElement> elementListBackUp = [];

  /// 存储选中的元素集合的中心点
  Offset elementListBackUpCenterPoint = Offset.zero;

  /// 存储套索封闭区域
  Path lassoBackUp = Path();

  /// 打开菜单
  openMenu({
    required Offset currentMenuPosition,
  }) {
    if (menuItems.isNotEmpty) {
      this.currentMenuPosition = currentMenuPosition;
      isShowMenu = true;
    }
  }

  /// 关闭菜单
  closeMenu() {
    isShowMenu = false;
    currentMenuPosition = Offset.zero;
  }

  /// 处理点击菜单项
  clickMenuItem(MenuItemEnum currentSelectItem) {
    isShowMenu = false;
    switch (currentSelectItem) {
      case MenuItemEnum.copy:
        elementListBackUp =
            selectedElementList.map((e) => e.deepCopy()).toList();
        elementListBackUpCenterPoint = selectedElementCenter;
        lassoBackUp = Path.from(lasso);
        resetLassoConfig();

        break;
      case MenuItemEnum.cut:
        elementListBackUp =
            selectedElementList.map((e) => e.deepCopy()).toList();
        elementListBackUpCenterPoint = selectedElementCenter;
        canvasElementList.removeWhere((canvasElementItem) =>
            selectedElementList.any((selectedElementItem) =>
                identical(canvasElementItem, selectedElementItem)));
        lassoBackUp = Path.from(lasso);
        resetLassoConfig();

        break;
      case MenuItemEnum.paste:
        if (elementListBackUp.isNotEmpty) {
          lassoStep = LassoStep.close;
          final distance = transformToCanvasPoint(currentMenuPosition) -
              elementListBackUpCenterPoint;
          final tempElementList =
              elementListBackUp.map((e) => e.deepCopy()).toList();
          for (var item in tempElementList) {
            item.translateElement(distance);
          }
          translateClosedShape(lasso: Path.from(lassoBackUp), offset: distance);
          canvasElementList = [
            ...canvasElementList,
            ...tempElementList,
          ];
          setSelectedElementList();
        }

        break;
      case MenuItemEnum.delete:
        canvasElementList.removeWhere((canvasElementItem) =>
            selectedElementList.any((selectedElementItem) =>
                identical(canvasElementItem, selectedElementItem)));

        resetLassoConfig();
        break;
    }
  }

  /// 菜单项列表
  List<MenuItemEnum> get menuItems {
    final pasteItem = elementListBackUp.isNotEmpty &&
            !isHitLassoCloseArea(transformToCanvasPoint(
              currentMenuPosition,
            ))
        ? [MenuItemEnum.paste]
        : [];
    final canOperate = isHitLassoCloseArea(transformToCanvasPoint(
              currentMenuPosition,
            )) &&
            selectedElementList.isNotEmpty
        ? [MenuItemEnum.copy, MenuItemEnum.cut, MenuItemEnum.delete]
        : [];
    return [...canOperate, ...pasteItem];
  }

  /// 重置菜单配置
  resetMenuConfig() {
    currentMenuPosition = Offset.zero;
    isShowMenu = false;
    lastMenuCopyOrCutPosition = Offset.zero;
  }
}
