// 构建一个菜单函数，传入位置、是否显示参数
// 菜单项有复制、粘贴、剪切、删除

import 'package:flutter/material.dart';
import 'package:flutter_application_2/modal/common_utils.dart';
import 'package:flutter_application_2/modal/menu_logic.dart';
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
            left: whiteBoardManager.menuConfig.menuPosition.dx,
            top: whiteBoardManager.menuConfig.menuPosition.dy,
            child: Offstage(
              offstage: !whiteBoardManager.menuConfig.isShowMenu,
              child: Container(
                width: 50,
                height: 100,
                color: Colors.grey,
                child: Column(
                  children: whiteBoardManager.menuConfig.menuItems
                      .map((e) => _menuItem(e))
                      .toList(),
                ),
              ),
            ));
      },
    );
  }

  Widget _menuItem(String title) {
    return GestureDetector(
      onTap: () {
        switch (title) {
          case '复制':
            whiteBoardManager.copyElement();
            break;
          case '粘贴':
            whiteBoardManager.pasteElement();
            break;
          case '剪切':
            whiteBoardManager.cutElement();
            break;
          case '删除':
            whiteBoardManager.deleteElement();
            break;
        }
      },
      child: Container(
        width: 50,
        height: 25,
        child: Text(title),
      ),
    );
  }
}
