import 'package:flutter/material.dart';
import 'package:flutter_application_2/modal/gesture_logic.dart';
import 'package:flutter_application_2/modal/transform_logic.dart';
import 'package:flutter_application_2/modal/white_board_manager.dart';
import 'package:get/get.dart';

class GestureLayer extends StatelessWidget {
  GestureLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WhiteBoardManager>(
      builder: (whiteBoardManager) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onScaleStart: whiteBoardManager.onScaleStart,
            onScaleUpdate: whiteBoardManager.onScaleUpdate,
            onScaleEnd: whiteBoardManager.onScaleEnd,
            // onLongPressDown: ,
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerDown: whiteBoardManager.onPointerDown,
              onPointerMove: whiteBoardManager.onPointerMove,
              onPointerUp: whiteBoardManager.onPointerUp,
            ),
          ),
        );
      },
    );
  }


}
