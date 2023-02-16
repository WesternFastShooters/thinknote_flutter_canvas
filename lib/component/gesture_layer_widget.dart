import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modal/board_modal.dart';

/// 手势层Widget
class GestureLayerWidget extends StatelessWidget {
  GestureLayerWidget({Key? key}) : super(key: key);

  final BoardModal boardModal = Get.find<BoardModal>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: _gestureDetectorWidget(),
    );
  }

  Widget _gestureDetectorWidget() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onScaleStart: (ScaleStartDetails details) {
        boardModal.onScaleStart(details);
      },
      onScaleUpdate: (ScaleUpdateDetails details) {
        boardModal.onScaleUpdate(details);
      },
      onScaleEnd: (ScaleEndDetails details) {
        boardModal.onScaleEnd(details);
      },
      child: _listenerWidget(),
    );
  }

  Widget _listenerWidget() {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerMove: (PointerMoveEvent event) {
        boardModal.onPointerMove(event);
      },
      onPointerUp: (PointerUpEvent e) {
        boardModal.onPointerUp(e);
      },
    );
  }
}
