import 'package:flutter/material.dart';
import 'package:flutter_application_2/component/background_layer_widget.dart';
import 'package:flutter_application_2/component/test_rect.dart';
import 'package:flutter_application_2/modal/board_modal.dart';
import 'package:get/get.dart';

import 'gesture_layer_widget.dart';

class BoardWidget extends StatelessWidget {
  BoardWidget({Key? key}) : super(key: key);
  final boardModal = Get.put(BoardModal());

  @override
  Widget build(BuildContext context) {
    boardModal.visibleAreaSize = MediaQuery.of(context).size;
    boardModal.visibleAreaCenter = Offset(
      MediaQuery.of(context).size.width / 2,
      MediaQuery.of(context).size.height / 2,
    );
    if (boardModal.curCanvasOffset == Offset.zero) {
      boardModal.curCanvasOffset = boardModal.visibleAreaCenter;
    }

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundLayerWidget(),
          const TestRect(),
          GestureLayerWidget(),
        ],
      ),
    );
  }
}
