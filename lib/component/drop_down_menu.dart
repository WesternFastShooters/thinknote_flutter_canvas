// 构建一个菜单函数，传入位置、是否显示参数
// 菜单项有复制、粘贴、剪切、删除

import 'package:flutter/material.dart';
import 'package:flutter_application_2/model/graphics_canvas.dart';
import 'package:flutter_application_2/model/tool/menu.dart';
import 'package:get/get.dart';

class DropDownMenu extends StatelessWidget {
  final GraphicsCanvas graphicsCanvas = Get.find<GraphicsCanvas>();

  DropDownMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GraphicsCanvas>(
      builder: (graphicsCanvas) {
        return Positioned(
            left: graphicsCanvas.triggerPosition.dx,
            top: graphicsCanvas.triggerPosition.dy,
            child: Offstage(
              offstage: !graphicsCanvas.isOpenMenu,
              child: Container(
                width: 50,
                height: 100,
                color: Colors.grey,
                child: Column(
                  children: graphicsCanvas.menuItems.map((e) => _menuItem(e)).toList(),
                ),
              ),
            ));
      },
    );
  }

  Widget _menuItem(MenuItemEnum mode) {
    return GestureDetector(
      onTap: () {
        graphicsCanvas.clickMenuItem(mode);
      },
      child: SizedBox(
        width: 50,
        height: 25,
        child: Text(mode.value),
      ),
    );
  }
}
