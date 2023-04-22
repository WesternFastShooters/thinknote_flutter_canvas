import 'package:dash_painter/dash_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/model/white_board_manager.dart';
import 'package:flutter_application_2/type/elementType/stroke_element.dart';
import 'package:flutter_application_2/type/elementType/whiteboard_element.dart';
import 'package:get/get.dart';

class WhiteBoardLayer extends StatelessWidget {
  const WhiteBoardLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WhiteBoardManager>(
      builder: (whiteBoardManager) {
        return Transform(
          transform: Matrix4.identity()
            ..translate(
              whiteBoardManager.whiteBoardModel.globalCanvasOffset.dx,
              whiteBoardManager.whiteBoardModel.globalCanvasOffset.dy,
            )
            ..scale(whiteBoardManager.whiteBoardModel.globalCanvasScale),
          child: RepaintBoundary(
            child: CustomPaint(
              isComplex: true,
              painter: WhiteBoardPainter(),
            ),
          ),
        );
      },
    );
  }
}

class WhiteBoardPainter extends CustomPainter {
  final WhiteBoardManager whiteBoardManager = Get.find<WhiteBoardManager>();

  @override
  void paint(Canvas canvas, Size size) {
    drawCanvasElementList(canvas);
    drawCurrentElement(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  /// 绘制所有画布元素
  drawCanvasElementList(Canvas canvas) {
    for (var item in whiteBoardManager.whiteBoardModel.canvasElementList) {
      switch (item.elementType) {
        case ElementType.stroke:
          if (item.isEmpty) continue;
          canvas.drawPath(item.path, (item as Stroke).paint);
          break;
        case ElementType.geometricShape:
          break;
      }
    }
  }

  /// 绘制正在绘制的元素
  drawCurrentElement(Canvas canvas) {
    switch (whiteBoardManager.whiteBoardModel.currentToolType) {
      case ActionType.freeDraw:
        drawCurrentPen(canvas);
        break;
      case ActionType.eraser:
        drawEraser(canvas);
        break;
      case ActionType.lasso:
        drawLasso(canvas);
        break;
    }
  }

  /// 绘制当前画笔
  drawCurrentPen(Canvas canvas) {
    final path = whiteBoardManager.whiteBoardModel.currentStroke.currentPath;
    final paint = whiteBoardManager.whiteBoardModel.currentStroke.paint;
    canvas.drawPath(path, paint);
  }

  /// 绘制橡皮擦
  drawEraser(Canvas canvas) {
    if (whiteBoardManager.whiteBoardModel.currentEraserPosition != null) {
      canvas.drawCircle(
        (whiteBoardManager.whiteBoardModel.currentEraserPosition as Offset),
        whiteBoardManager.whiteBoardModel.eraserRadius,
        Paint()
          ..color = Colors.blue
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke,
      );
    }
  }

  /// 绘制套索
  drawLasso(Canvas canvas) {
    final lasso = whiteBoardManager.whiteBoardModel.lasso;
    final paint = whiteBoardManager.whiteBoardModel.paint;
    const DashPainter(span: 4, step: 9).paint(canvas, lasso, paint);
  }
}
