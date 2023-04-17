import 'dart:ui';
import 'package:flutter_application_2/type/elementType/element_container.dart';
import 'package:flutter_application_2/type/elementType/white_element.dart';

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

class MenuConfig {
  /// 是否展示菜单
  bool isShowMenu = false;

  /// 当前菜单展开位置
  Offset currentMenuPosition = Offset.zero;

  /// 上一次所点击的菜单项
  MenuItemEnum lastSelectItem = MenuItemEnum.none;

  /// 菜单选项列表
  List<MenuItemEnum> menuItems = [];

  /// 上一次复制或者粘贴的位置
  Offset lastMenuCopyOrCutPosition = Offset.zero;

  /// 存储备份的元素
  List<ElementContainer<WhiteElement>> copiedElementList = [];


  /// 重置菜单配置
  resetMenuConfig() {
    currentMenuPosition = Offset.zero;
    isShowMenu = false;
    menuItems = [];
    lastSelectItem = MenuItemEnum.none;
    lastMenuCopyOrCutPosition = Offset.zero;
  }
}
