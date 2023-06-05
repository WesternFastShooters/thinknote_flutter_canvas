import 'package:dash_painter/dash_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/model/graphics_canvas.dart';
import 'package:flutter_application_2/model/store/canvas_store.dart';
import 'package:get/get.dart';

class WhiteBoardLayer extends StatelessWidget {
  const WhiteBoardLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GraphicsCanvas>(
      builder: (graphicsCanvas) {
        return Transform(
          transform: Matrix4.identity()
            ..translate(
              graphicsCanvas.canvasOffset.dx,
              graphicsCanvas.canvasOffset.dy,
            )
            ..scale(graphicsCanvas.canvasScale),
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
  final GraphicsCanvas graphicsCanvas = Get.find<GraphicsCanvas>();

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
    for (var item in graphicsCanvas.strokeList) {
      canvas.drawPath(item.path, item.paint);
    }
    // for (var item in graphicsCanvas.shapeList) {
    // }
  }

  /// 绘制正在绘制的元素
  drawCurrentElement(Canvas canvas) {
    switch (graphicsCanvas.currentToolType) {
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
    final path = graphicsCanvas.currentStrokePath;
    final paint = graphicsCanvas.currentStrokePaint;
    canvas.drawPath(path, paint);
  }

  /// 绘制橡皮擦
  drawEraser(Canvas canvas) {
    if (graphicsCanvas.eraserPosition != null) {
      canvas.drawCircle(
        (graphicsCanvas.eraserPosition as Offset),
        graphicsCanvas.eraserRadius,
        Paint()
          ..color = Colors.blue
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke,
      );
    }
  }

  /// 绘制套索
  drawLasso(Canvas canvas) {
    final lasso = graphicsCanvas.selectedArea.trackPath;
    final paint = graphicsCanvas.lassoPaint;
    const DashPainter(span: 4, step: 9).paint(canvas, lasso, paint);
  }
}
