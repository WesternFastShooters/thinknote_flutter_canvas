// 构建一个菜单函数，传入位置、是否显示参数
// 菜单项有复制、粘贴、剪切、删除

import 'package:flutter/material.dart';
import 'package:flutter_application_2/model/menu/menu_model.dart';
import 'package:flutter_application_2/model/white_board_manager.dart';
import 'package:get/get.dart';

class DropDownMenu extends StatelessWidget {
  final WhiteBoardManager whiteBoardManager = Get.find<WhiteBoardManager>();

  DropDownMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WhiteBoardManager>(
      builder: (whiteBoardManager) {
        return Positioned(
            left: whiteBoardManager.whiteBoardModel.currentMenuPosition.dx,
            top: whiteBoardManager.whiteBoardModel.currentMenuPosition.dy,
            child: Offstage(
              offstage: !whiteBoardManager.whiteBoardModel.isShowMenu,
              child: Container(
                width: 50,
                height: 100,
                color: Colors.grey,
                child: Column(
                  children: whiteBoardManager.whiteBoardModel.menuItems
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
