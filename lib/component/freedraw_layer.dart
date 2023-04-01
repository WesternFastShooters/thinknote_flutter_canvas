import 'package:flutter/material.dart';
import 'package:flutter_application_2/modal/freedraw_logic.dart';
import 'package:flutter_application_2/modal/transform_logic.dart';
import 'package:get/get.dart';

class FreeDrawLayer extends StatelessWidget {
  final transformLogic = Get.find<TransformLogic>();
  final freedrawLogic = Get.find<FreeDrawLogic>();
  FreeDrawLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..translate(
          transformLogic.curCanvasOffset.dx,
          transformLogic.curCanvasOffset.dy,
        )
        ..scale(transformLogic.curCanvasScale),
      child: Stack(children: [
        buildAllPaths(context),
        buildCurrentPath(context),
      ]),
    );
    // return GetBuilder(
    //   builder: (_) {
    //     return Transform(
    //       transform: Matrix4.identity()
    //         ..translate(
    //           transformLogic.curCanvasOffset.dx,
    //           transformLogic.curCanvasOffset.dy,
    //         )
    //         ..scale(transformLogic.curCanvasScale),
    //       child: Stack(children: [
    //         buildAllPaths(context),
    //         buildCurrentPath(context),
    //       ]),
    //     );
    //   },
    // );
  }

  /// 绘制当前笔画
  Widget buildCurrentPath(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        isComplex: true,
        painter: Sketcher(
          propStrokes: freedrawLogic.currentStroke.isEmpty
              ? []
              : [freedrawLogic.currentStroke],
          options: freedrawLogic.currentStrokeOption,
        ),
      ),
    );
  }

  /// 绘制所有笔画
  Widget buildAllPaths(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        isComplex: true,
        painter: Sketcher(
          propStrokes: freedrawLogic.strokes,
          options: freedrawLogic.currentStrokeOption,
        ),
      ),
    );
  }
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
