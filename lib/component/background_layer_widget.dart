import 'package:flutter/material.dart';
import 'package:flutter_application_2/constants/canvas_id.dart';
import 'package:flutter_application_2/modal/board_modal.dart';
import 'package:get/get.dart';

class BackgroundLayerWidget extends StatelessWidget {
  const BackgroundLayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BoardModal>(
      id: CanvasID.backgroundLayerWidgetId,
      builder: (BoardModal boardModal) {
        return Transform(
          transform: Matrix4.identity()
            ..translate(
                boardModal.curCanvasOffset.dx, boardModal.curCanvasOffset.dy),
          child: RepaintBoundary(
            child: CustomPaint(
              isComplex: true,
              painter: _BackgroundLayerWidget(),
            ),
          ),
        );
      },
    );
  }
}

class _BackgroundLayerWidget extends CustomPainter {
  final BoardModal boardModal = Get.find<BoardModal>();

  var rect = const Rect.fromLTWH(100, 100, 300, 300);
  var painter = Paint()..color = Colors.yellow;
  @override
  void paint(Canvas canvas, Size size) {
    debugPrint("BackgroundLayerWidget===repaint");
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
