import 'package:flutter/material.dart';
import 'package:flutter_application_2/modal/gesture_logic_board.dart';
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

  // 专门用来做可触控设备上（大屏端、pad端、手机端）对画布进行的多指缩放操作
  //
  // 注意多指缩放的过程中也会触发平移平移操作
  Widget _gestureDetectorWidget() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: _listenerWidget(),
    );
  }

  // 这个做的就多了，无论什么端：画布的平移操作、鼠标滚轮和触控板对画布的缩放操作、所有的绘制事件等
  Widget _listenerWidget() {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerMove: (PointerMoveEvent event) {
        boardModal.onPointerMove(event);
      },
    );
  }
}
