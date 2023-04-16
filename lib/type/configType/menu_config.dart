import 'dart:ui';

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
  /// 当前菜单展开位置
  Offset currentMenuPosition = Offset.zero;


  /// 上一次展开位置
  Offset lastMenuPosition = Offset.zero;

  /// 最新选择的操作
  MenuItemEnum latestSelectItem = MenuItemEnum.none;
  setLatestSelectItem(MenuItemEnum item) => latestSelectItem = item;

  /// 菜单是否展示
  bool isShowMenu = false;

  /// 菜单选项
  List<MenuItemEnum> menuItems = [];

  /// 展开或关闭菜单
  openMenu(
      {required Offset currentMenuPosition,
      required List<MenuItemEnum> menuItems}) {
    this.currentMenuPosition = currentMenuPosition;
    isShowMenu = true;
    this.menuItems = menuItems;
  }

  /// 配置重置
  reset() {
    currentMenuPosition = Offset.zero;
    isShowMenu = false;
    menuItems = [];
    latestSelectItem = MenuItemEnum.none;
    lastMenuPosition = Offset.zero;
  }
}
