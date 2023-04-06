import 'package:flutter/material.dart';
import 'package:flutter_application_2/modal/white_board_manager.dart';
import 'package:flutter_application_2/type/stroke.dart';
import 'package:flutter_application_2/type/white_board_element.dart';
import 'package:get/get.dart';

class WhiteBoardLayer extends StatelessWidget {
  const WhiteBoardLayer({super.key});

  @override
  Widget build(BuildContext context) {
    final WhiteBoardManager whiteBoardManager = Get.find<WhiteBoardManager>();
    whiteBoardManager.transformConfig['visibleAreaSize'] =
        MediaQuery.of(context).size;
    whiteBoardManager.transformConfig['visibleAreaCenter'] = Offset(
      MediaQuery.of(context).size.width / 2,
      MediaQuery.of(context).size.height / 2,
    );
    if (whiteBoardManager.transformConfig['curCanvasOffset'] == Offset.zero) {
      whiteBoardManager.transformConfig['curCanvasOffset'] =
          whiteBoardManager.transformConfig['visibleAreaCenter'];
    }
    return GetBuilder<WhiteBoardManager>(
      builder: (whiteBoardManager) {
        return Transform(
          transform: Matrix4.identity()
            ..translate(
              whiteBoardManager.transformConfig['curCanvasOffset'].dx,
              whiteBoardManager.transformConfig['curCanvasOffset'].dy,
            )
            ..scale(whiteBoardManager.transformConfig['curCanvasScale']),
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
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  /// 绘制所有画布元素
  drawCanvasElementList(Canvas canvas) {
    for (var item in whiteBoardManager.canvasElementList) {
      switch (item.type) {
        case WhiteBoardElementType.stroke:
          if ((item.element as Stroke).path == null) continue;
          canvas.drawPath(
              (item.element as Stroke).path!, (item.element as Stroke).paint);
          break;
        case WhiteBoardElementType.geometricShape:
          break;
      }
    }
  }

  /// 绘制正在绘制的元素
  drawCurrentElement(Canvas canvas) {
    switch (whiteBoardManager.currentToolType) {
      case ToolType.transform:
        break;
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
    final path = (whiteBoardManager.drawingCanvasElementList[0]
            as WhiteBoardElement<Stroke>)
        .element
        .path;
    final paint = (whiteBoardManager.drawingCanvasElementList[0]
            as WhiteBoardElement<Stroke>)
        .element
        .paint;
    if (path != null) {
      canvas.drawPath(path, paint);
    }
  }

  /// 绘制橡皮擦
  drawEraser(Canvas canvas) {
    if (whiteBoardManager.eraserConfig['currentEraserPosition'] != null) {
      canvas.drawCircle(
        whiteBoardManager.eraserConfig['currentEraserPosition'],
        whiteBoardManager.eraserConfig['eraserRadius'],
        Paint()
          ..color = Colors.blue
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke,
      );
    }
  }
}
