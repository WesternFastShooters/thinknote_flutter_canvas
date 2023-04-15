// 构建一个菜单函数，传入位置、是否显示参数
// 菜单项有复制、粘贴、剪切、删除

import 'package:flutter/material.dart';
import 'package:flutter_application_2/modal/common_utils.dart';
import 'package:flutter_application_2/modal/white_board_manager.dart';
import 'package:get/get.dart';

class DropDownMenu extends StatelessWidget {
  DropDownMenu(
      {super.key, required this.isShowMenu, required this.menuPosition});
  final bool isShowMenu;
  final Offset menuPosition;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WhiteBoardManager>(
      builder: (whiteBoardManager) {
        final canvasPosition =
            whiteBoardManager.transformToCanvasPoint(menuPosition);
        return Positioned(
          left: canvasPosition.dx,
          top: canvasPosition.dy,
          child: Offstage(
            offstage: !isShowMenu,
            child: Container(
              width: 100,
              height: 100,
              color: Colors.white,
              child: Column(
                children: whiteBoardManager.menuConfig.menuItems
                    .map((e) => _menuItem(e))
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _menuItem(String title) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 100,
        height: 25,
        child: Text(title),
      ),
    );
  }
}
