import 'package:flutter/material.dart';
import 'package:flutter_application_2/modal/board_modal.dart';
import 'package:get/get.dart';

class TestRect extends StatelessWidget {
  const TestRect({super.key});
  
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BoardModal>(
      builder: (BoardModal boardModal) {
        return Transform(
          transform: Matrix4.identity()
            ..translate(
              boardModal.curCanvasOffset.dx,
              boardModal.curCanvasOffset.dy,
            )
            ..scale(boardModal.curCanvasScale),
          child: RepaintBoundary(
            child: CustomPaint(
              isComplex: true,
              painter: _TestRect(),
            ),
          ),
        );
      },
    );
  }
}

class _TestRect extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var rect = Rect.fromLTWH(100, 100, 300, 400);
    var painter = Paint()..color = Colors.yellow;
    canvas.drawRect(rect, painter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
