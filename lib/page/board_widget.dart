import 'package:flutter/material.dart';
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
    whiteBoardManager.transformConfig.visibleAreaSize =
        MediaQuery.of(context).size;
    whiteBoardManager.transformConfig.visibleAreaCenter = Offset(
      MediaQuery.of(context).size.width / 2,
      MediaQuery.of(context).size.height / 2,
    );
    if (whiteBoardManager.transformConfig.globalCanvasOffset == Offset.zero) {
      whiteBoardManager.transformConfig.globalCanvasOffset =
          whiteBoardManager.transformConfig.visibleAreaCenter;
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
        ],
      ),
    );
  }
}
