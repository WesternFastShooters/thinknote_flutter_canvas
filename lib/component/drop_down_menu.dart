// 构建一个菜单函数，传入位置、是否显示参数
// 菜单项有复制、粘贴、剪切、删除

import 'package:flutter/material.dart';
import 'package:flutter_application_2/modal/menu/menu_config.dart';
import 'package:flutter_application_2/modal/menu/menu_function.dart';
import 'package:flutter_application_2/modal/white_board_manager.dart';
import 'package:get/get.dart';

class DropDownMenu extends StatelessWidget {
  final WhiteBoardManager whiteBoardManager = Get.find<WhiteBoardManager>();

  DropDownMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WhiteBoardManager>(
      builder: (whiteBoardManager) {
        return Positioned(
            left: whiteBoardManager.whiteBoardConfig.currentMenuPosition.dx,
            top: whiteBoardManager.whiteBoardConfig.currentMenuPosition.dy,
            child: Offstage(
              offstage: !whiteBoardManager.whiteBoardConfig.isShowMenu,
              child: Container(
                width: 50,
                height: 100,
                color: Colors.grey,
                child: Column(
                  children: whiteBoardManager.whiteBoardConfig.menuItems
                      .map((e) => _menuItem(e))
                      .toList(),
                ),
              ),
            ));
      },
    );
  }

  Widget _menuItem(MenuItemEnum title) {
    return GestureDetector(
      onTap: () {
        whiteBoardManager.clickMenuItem(title);
      },
      child: SizedBox(
        width: 50,
        height: 25,
        child: Text(title.value),
      ),
    );
  }
}
