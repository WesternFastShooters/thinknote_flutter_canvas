import 'package:dash_painter/dash_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/modal/lasso/lasso_config.dart';
import 'package:flutter_application_2/modal/white_board_manager.dart';
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
              whiteBoardManager.whiteBoardConfig.globalCanvasOffset.dx,
              whiteBoardManager.whiteBoardConfig.globalCanvasOffset.dy,
            )
            ..scale(whiteBoardManager.whiteBoardConfig.globalCanvasScale),
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
    for (var item in whiteBoardManager.whiteBoardConfig.canvasElementList) {
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
    switch (whiteBoardManager.whiteBoardConfig.currentToolType) {
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
    if (whiteBoardManager.whiteBoardConfig.currentStroke.isEmpty) return;
    final path = whiteBoardManager.whiteBoardConfig.currentStroke.currentPath;
    final paint = whiteBoardManager.whiteBoardConfig.currentStroke.paint;
    canvas.drawPath(path, paint);
  }

  /// 绘制橡皮擦
  drawEraser(Canvas canvas) {
    if (whiteBoardManager.whiteBoardConfig.currentEraserPosition != null) {
      canvas.drawCircle(
        (whiteBoardManager.whiteBoardConfig.currentEraserPosition as Offset),
        whiteBoardManager.whiteBoardConfig.eraserRadius,
        Paint()
          ..color = Colors.blue
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke,
      );
    }
  }

  /// 绘制套索
  drawLasso(Canvas canvas) {
    if (whiteBoardManager.whiteBoardConfig.isEmpty) return;
    switch (whiteBoardManager.whiteBoardConfig.lassoStep) {
      case LassoStep.drawLine:
        _drawLassoLine(canvas);
        break;
      case LassoStep.close:
        _drawClosedShapePolygon(canvas);
        break;
    }
  }

  /// 绘制套索虚线
  _drawLassoLine(Canvas canvas) {
    if (whiteBoardManager.whiteBoardConfig.isEmpty) return;
    final path = whiteBoardManager.whiteBoardConfig.lassoPath!;
    final paint = whiteBoardManager.whiteBoardConfig.paint;
    const DashPainter(span: 4, step: 9).paint(canvas, path, paint);
  }

  /// 绘制套索闭合区域
  _drawClosedShapePolygon(Canvas canvas) {
    if (!whiteBoardManager.whiteBoardConfig.isConvexity) return;
    final path = whiteBoardManager.whiteBoardConfig.closedShapePath!;
    final paint = whiteBoardManager.whiteBoardConfig.paint;
    const DashPainter(span: 4, step: 9).paint(canvas, path, paint);
  }
}
