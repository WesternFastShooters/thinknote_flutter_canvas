import 'package:flutter/material.dart';
import 'package:flutter_application_2/modal/board_modal.dart';
import 'package:flutter_application_2/modal/stroke.dart';
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
              propStrokes: boardModal.currentStroke.isEmpty
                  ? []
                  : [boardModal.currentStroke],
              options: boardModal.currentStrokeOption,
            ),
          ),
        ),
      );
    },
  );
}

/// 绘制所有笔画
Widget buildAllPaths(BuildContext context) {
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
              propStrokes: boardModal.strokes,
              options: boardModal.currentStrokeOption,
            ),
          ),
        ),
      );
    },
  );
}

class Sketcher extends CustomPainter {
  final List<Stroke> propStrokes; // 用List表示一笔或者多笔，
  final Map options;

  Sketcher({required this.propStrokes, required this.options});

  @override
  void paint(Canvas canvas, Size size) {
    for (var item in propStrokes) {
      final path = item.pathCanvas['path'];
      final paint = item.pathCanvas['paint'];
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(Sketcher oldDelegate) {
    return true;
  }
}
