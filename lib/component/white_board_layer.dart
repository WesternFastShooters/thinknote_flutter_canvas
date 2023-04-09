import 'package:dash_painter/dash_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/modal/white_board_manager.dart';
import 'package:flutter_application_2/type/configType/lasso_config.dart';
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
    if (whiteBoardManager.freedrawConfig.currentStroke.path == null) return;
    final path = whiteBoardManager.freedrawConfig.currentStroke.path;
    final paint = whiteBoardManager.freedrawConfig.currentStroke.paint;
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

  /// 绘制套索虚线
  drawLasso(Canvas canvas) {
    if (whiteBoardManager.lassoConfig.lassoPathPoints.isEmpty) return;
    switch (whiteBoardManager.lassoConfig.lassoStep) {
      case LassoStep.drawLine:
        _drawLassoLine(canvas);
        break;
      case LassoStep.close:
        _drawClosedShapePolygon(canvas);
        break;
    }
   
  }

  _drawLassoLine(Canvas canvas) {
     final Paint paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeJoin = StrokeJoin.miter;

    final Path path = Path();
    path.moveTo(whiteBoardManager.lassoConfig.lassoPathPoints[0].dx,
        whiteBoardManager.lassoConfig.lassoPathPoints[0].dy);
    for (int i = 1;
        i < whiteBoardManager.lassoConfig.lassoPathPoints.length;
        i++) {
      path.lineTo(whiteBoardManager.lassoConfig.lassoPathPoints[i].dx,
          whiteBoardManager.lassoConfig.lassoPathPoints[i].dy);
    }
    const DashPainter(span: 4, step: 9).paint(canvas, path, paint);
  }

  /// 绘制套索闭合区域
  _drawClosedShapePolygon(Canvas canvas) {
    if (whiteBoardManager.lassoConfig.lassoPathPoints.isEmpty) return;
    final Paint paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeJoin = StrokeJoin.miter;

    final Path path = Path();
    path.moveTo(whiteBoardManager.lassoConfig.lassoPathPoints[0].dx,
        whiteBoardManager.lassoConfig.lassoPathPoints[0].dy);
    for (int i = 1;
        i < whiteBoardManager.lassoConfig.lassoPathPoints.length;
        i++) {
      path.lineTo(whiteBoardManager.lassoConfig.lassoPathPoints[i].dx,
          whiteBoardManager.lassoConfig.lassoPathPoints[i].dy);
    }
    path.close();
    const DashPainter(span: 4, step: 9).paint(canvas, path, paint);
    
  }
}
