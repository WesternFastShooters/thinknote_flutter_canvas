import 'package:flutter/material.dart';
import 'package:flutter_application_2/component/drop_down_menu.dart';
import 'package:flutter_application_2/component/gesture_layer.dart';
import 'package:flutter_application_2/component/toolbar.dart';
import 'package:flutter_application_2/component/white_board_layer.dart';
import 'package:flutter_application_2/modal/white_board_manager.dart';
import 'package:get/get.dart';

class BoardWidget extends StatelessWidget {
  BoardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final whiteBoardManager = Get.find<WhiteBoardManager>();
    whiteBoardManager.whiteBoardConfig.visibleAreaSize =
        MediaQuery.of(context).size;
    whiteBoardManager.whiteBoardConfig.visibleAreaCenter = Offset(
      MediaQuery.of(context).size.width / 2,
      MediaQuery.of(context).size.height / 2,
    );
    if (whiteBoardManager.whiteBoardConfig.globalCanvasOffset == Offset.zero) {
      whiteBoardManager.whiteBoardConfig.globalCanvasOffset =
          whiteBoardManager.whiteBoardConfig.visibleAreaCenter;
    }

    return Scaffold(
      body: Stack(
        children: [
          // LassoLayer(),
          WhiteBoardLayer(),
          GestureLayer(),
          const Positioned(
            top: 20,
            right: 20,
            child: ToolBar(),
          ),
          DropDownMenu()
        ],
      ),
    );
  }
}
