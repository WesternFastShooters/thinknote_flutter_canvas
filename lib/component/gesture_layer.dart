import 'package:flutter/material.dart';
import 'package:flutter_application_2/modal/white_board_base.dart';
import 'package:get/get.dart';

class GestureLayer extends StatelessWidget {
  GestureLayer({super.key});

  final whiteBoardBase = Get.find<WhiteBoardBase>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WhiteBoardBase>(
      builder: (whiteBoardBase) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onScaleStart: whiteBoardBase.onScaleStart,
            onScaleUpdate: whiteBoardBase.onScaleUpdate,
            onScaleEnd: whiteBoardBase.onScaleEnd,
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerDown: whiteBoardBase.onPointerDown,
              onPointerMove: whiteBoardBase.onPointerMove,
              onPointerUp: whiteBoardBase.onPointerUp,
            ),
          ),
        );
      },
    );
  }
}
