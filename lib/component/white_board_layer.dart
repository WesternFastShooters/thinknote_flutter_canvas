import 'package:flutter/material.dart';
import 'package:flutter_application_2/modal/white_board_manager.dart';
import 'package:flutter_application_2/type/elementType/stroke_type.dart';
import 'package:flutter_application_2/type/elementType/element_container.dart';
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
              whiteBoardManager.transformConfig.curCanvasOffset.dx,
              whiteBoardManager.transformConfig.curCanvasOffset.dy,
            )
            ..scale(whiteBoardManager.transformConfig.curCanvasScale),
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
    for (var item in whiteBoardManager.canvasElementList) {
      switch (item.type) {
        case ElementType.stroke:
          if ((item.element as Stroke).path == null) continue;
          canvas.drawPath(
              (item.element as Stroke).path!, (item.element as Stroke).paint);
          break;
        case ElementType.geometricShape:
          break;
      }
    }
  }

  /// 绘制正在绘制的元素
  drawCurrentElement(Canvas canvas) {
    switch (whiteBoardManager.currentToolType) {
      case ToolType.freeDraw:
        drawCurrentPen(canvas);
        break;
      case ToolType.eraser:
        drawEraser(canvas);
        break;
      case ToolType.lasso:
        break;
      case ToolType.drag:
        break;
    }
  }

  /// 绘制当前画笔
  drawCurrentPen(Canvas canvas) {
    if (whiteBoardManager.drawingCanvasElementList.isEmpty) {
      return;
    }
    final path = (whiteBoardManager.drawingCanvasElementList[0]
            as ElementContainer<Stroke>)
        .element
        .path;
    final paint = (whiteBoardManager.drawingCanvasElementList[0]
            as ElementContainer<Stroke>)
        .element
        .paint;
    if (path != null) {
      canvas.drawPath(path, paint);
    }
  }

  /// 绘制橡皮擦
  drawEraser(Canvas canvas) {
    if (whiteBoardManager.eraserConfig.currentEraserPosition != null) {
      canvas.drawCircle(
        (whiteBoardManager.eraserConfig.currentEraserPosition as Offset),
        whiteBoardManager.eraserConfig.eraserRadius,
        Paint()
          ..color = Colors.blue
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke,
      );
    }
  }
}
