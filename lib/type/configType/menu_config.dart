import 'dart:ui';

class MenuConfig {
  /// 菜单展开位置
  Offset menuPosition = Offset.zero;

  /// 菜单是否展示
  bool isShowMenu = false;

  /// 菜单选项
  List<String> menuItems = [];

  /// 展开或关闭菜单
  showMenu(
      {required Offset menuPosition,
      required bool isShowMenu,
      required List<String> menuItems}) {
    this.menuPosition = menuPosition;
    this.isShowMenu = isShowMenu;
    this.menuItems = menuItems;
  }
}
