import 'package:flutter/material.dart';
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
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerDown: (event) async {
                await whiteBoardManager.onPointerDown(event);
              },
              onPointerMove: (event) async {
                await whiteBoardManager.onPointerMove(event);
              },
              onPointerUp: whiteBoardManager.onPointerUp,
            ),
          ),
        );
      },
    );
  }
}
