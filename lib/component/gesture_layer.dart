import 'package:flutter/material.dart';
import 'package:flutter_application_2/modal/board_modal.dart';
import 'package:flutter_application_2/modal/logic/drag_logic.dart';
import 'package:get/get.dart';

class GestureLayer extends StatelessWidget {
  const GestureLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BoardModal>(
      builder: (BoardModal boardModal) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onScaleStart: boardModal.onScaleStart,
            onScaleUpdate: boardModal.onScaleUpdate,
            onScaleEnd: boardModal.onScaleEnd,
      
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerDown: boardModal.onPointerDown,
              onPointerMove: boardModal.onPointerMove,
              onPointerUp: boardModal.onPointerUp,
              
            ),
          ),
        );
      },
    );
  }
}
