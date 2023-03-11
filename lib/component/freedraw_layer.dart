import 'package:flutter/material.dart';
import 'package:flutter_application_2/modal/board_modal.dart';
import 'package:flutter_application_2/modal/logic/freedraw_logic.dart';
import 'package:flutter_application_2/modal/type/pencil_element_model.dart';
import 'package:get/get.dart';
import 'package:perfect_freehand/perfect_freehand.dart';

class FreeDrawLayer extends StatelessWidget {
  const FreeDrawLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      buildAllPaths(context),
      buildCurrentPath(context),
    ]);
  }
}

/// 绘制当前笔画
Widget buildCurrentPath(BuildContext context) {
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
            painter: Sketcher(
              strokes: boardModal.currentStroke == null
                  ? []
                  : [boardModal.currentStroke!],
              options: boardModal.currentStrokeOptions,
            ),
          ),
        ),
      );
    },
  );
}

/// 绘制所有笔画
Widget buildAllPaths(BuildContext context) {
  final BoardModal boardModal = Get.find<BoardModal>();
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
            painter: Sketcher(
              strokes: boardModal.strokes,
              options: boardModal.currentStrokeOptions,
            ),
          ),
        ),
      );
    },
  );
}

class Sketcher extends CustomPainter {
  final List<Stroke> strokes;
  final StrokeOptions options;

  Sketcher({required this.strokes, required this.options});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.green;

    for (int i = 0; i < strokes.length; ++i) {
      final outlinePoints = getStroke(
        strokes[i].strokePoints,
        size: 3,
        thinning: 0.1,
        smoothing: options.smoothing,
        streamline: options.streamline,
        taperStart: options.taperStart,
        capStart: options.capStart,
        taperEnd: 0.1,
        capEnd: options.capEnd,
        simulatePressure: options.simulatePressure,
        isComplete: options.isComplete,
      );

      final path = Path();

      if (outlinePoints.isEmpty) {
        return;
      } else if (outlinePoints.length < 2) {
        // If the path only has one currentStroke, draw a dot.
        path.addOval(Rect.fromCircle(
            center: Offset(outlinePoints[0].x, outlinePoints[0].y), radius: 1));
      } else {
        // Otherwise, draw a currentStroke that connects each point with a curve.
        path.moveTo(outlinePoints[0].x, outlinePoints[0].y);

        for (int i = 1; i < outlinePoints.length - 1; ++i) {
          final p0 = outlinePoints[i];
          final p1 = outlinePoints[i + 1];
          path.quadraticBezierTo(
              p0.x, p0.y, (p0.x + p1.x) / 2, (p0.y + p1.y) / 2);
        }
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(Sketcher oldDelegate) {
    
    return true;
  }
}
