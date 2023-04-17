import 'package:flutter/widgets.dart';
import 'package:flutter_application_2/modal/gesture_logic.dart';
import 'package:flutter_application_2/modal/menu_logic.dart';
import 'package:flutter_application_2/modal/transform_logic.dart';
import 'package:flutter_application_2/modal/white_board_manager.dart';
import 'package:get/get.dart';

class GestureLayer extends StatelessWidget {
  GestureLayer({super.key});

  @override
  Widget build(BuildContext context) {
    /// 指头编号
    int currentPointerId = -1;
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
            onDoubleTapDown: whiteBoardManager.onDoubleTapDown,
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerDown: (event) {
                if (currentPointerId != -1) {
                  return;
                }
                currentPointerId = event.pointer;
                whiteBoardManager.onPointerDown(event);
              },
              onPointerMove: (event) {
                if (event.pointer != currentPointerId) {
                  return;
                }
                whiteBoardManager.onPointerMove(event);
              },
              onPointerUp: (event) {
                if (event.pointer != currentPointerId) {
                  return;
                }
                currentPointerId = -1;
                whiteBoardManager.onPointerUp(event);
              },
            ),
          ),
        );
      },
    );
  }
}
