import 'package:flutter/material.dart';
import 'package:flutter_application_2/component/eraser_layer.dart';
import 'package:flutter_application_2/component/freedraw_layer.dart';
import 'package:flutter_application_2/component/gesture_layer.dart';
import 'package:flutter_application_2/component/lasso_layer.dart';
import 'package:flutter_application_2/component/toolbar.dart';
import 'package:flutter_application_2/modal/transform_logic.dart';
import 'package:get/get.dart';

class BoardWidget extends StatelessWidget {
  BoardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final transformLogic = Get.find<TransformLogic>();
    transformLogic.visibleAreaSize = MediaQuery.of(context).size;
    transformLogic.visibleAreaCenter = Offset(
      MediaQuery.of(context).size.width / 2,
      MediaQuery.of(context).size.height / 2,
    );
    if (transformLogic.curCanvasOffset == Offset.zero) {
      transformLogic.curCanvasOffset = transformLogic.visibleAreaCenter;
    }

    return Scaffold(
      body: Stack(
        children: [
          FreeDrawLayer(),
          EraserLayer(),
          LassoLayer(),
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
