import 'dart:ui' as ui;
import 'package:flutter/gestures.dart';
import 'package:flutter_application_2/model/store/canvas_store.dart';
import 'package:flutter_application_2/model/tool/lasso.dart';

enum ClickType {
  single,
  double,
}

enum MenuItemEnum {
  copy,
  delete,
  paste,
  cut,
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
    }
  }
}

mixin Menu on Lasso, CanvasStore {
  /// 是否打开菜单
  bool isOpenMenu = false;

  /// 触发菜单位置
  ui.Offset triggerPosition = ui.Offset.zero;

  /// 菜单项
  List<MenuItemEnum> menuItems = [];

  initMenu() {
    isOpenMenu = false;
    triggerPosition = ui.Offset.zero;
    menuItems = [];
  }

  /// 当意图展开菜单时执行
  trigger(ui.Offset triggerPosition, ClickType type) {
    switch (type) {
      case ClickType.single:
        initMenu();
        break;
      case ClickType.double:
        menuItems = [
          if (selectedArea.hasSelectedContent &&
              hitLassoCloseArea(triggerPosition))
            MenuItemEnum.copy,
          if (selectedArea.hasSelectedContent &&
              hitLassoCloseArea(triggerPosition))
            MenuItemEnum.cut,
          if (selectedArea.hasSelectedContent &&
              hitLassoCloseArea(triggerPosition))
            MenuItemEnum.delete,
          if (casheArea.hasCasheContent) MenuItemEnum.paste,
        ];
        if (menuItems.isNotEmpty) {
          isOpenMenu = true;
          this.triggerPosition = triggerPosition;
        }

        break;
    }
  }
}

extension MenuGesture on Menu {
  onMenuDown(PointerDownEvent event) {
    trigger(event.localPosition, ClickType.single);
  }

  onMenuDoubleTapDown(TapDownDetails details) {
    trigger(details.localPosition, ClickType.double);
  }
}
