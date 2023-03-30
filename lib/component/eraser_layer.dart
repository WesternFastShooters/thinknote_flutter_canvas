import 'package:flutter/material.dart';
import 'package:flutter_application_2/modal/board_modal.dart';
import 'package:flutter_application_2/modal/logic/freedraw_logic.dart';
import 'package:flutter_application_2/modal/type/pencil_element_model.dart';
import 'package:get/get.dart';
import 'package:perfect_freehand/perfect_freehand.dart';

class EraserLayer extends StatelessWidget {
  const EraserLayer({super.key});

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
              painter: Eraser(eraserLocation: boardModal.currentEraserPosition),
            ),
          ) ,
        );
      },
    );
  }
}

class Eraser extends CustomPainter {
  final BoardModal boardModal = Get.find<BoardModal>();

  late Offset? eraserLocation;

  // 构造函数
  Eraser({this.eraserLocation});

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制一个半径为10的圆形，颜色为蓝色
    if (eraserLocation != null) {
      canvas.drawCircle(eraserLocation!, boardModal.eraserRadius,
          Paint()..color = Colors.blue);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
