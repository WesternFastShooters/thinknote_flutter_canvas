import 'package:flutter/material.dart';
import 'package:flutter_application_2/modal/freedraw_logic.dart';
import 'package:flutter_application_2/modal/transform_logic.dart';
import 'package:get/get.dart';

class FreeDrawController extends GetxController {
  final freeDrawLogic = Get.find<FreeDrawLogic>();
  final transformLogic = Get.find<TransformLogic>();

  Rx<Offset> get curCanvasOffset => transformLogic.curCanvasOffset;
  Rx<double> get curCanvasScale => transformLogic.curCanvasScale;
  Rx<Stroke> get currentStroke => freeDrawLogic.currentStroke;
  RxList<Stroke> get strokes => freeDrawLogic.strokes;

  @override
  void onInit() {
    super.onInit();
    everAll([curCanvasOffset, curCanvasScale, currentStroke, strokes], (_) {
      update();
    });
  }
}

class FreeDrawLayer extends StatelessWidget {
  FreeDrawLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<FreeDrawController>(
      init: FreeDrawController(),
      builder: (FreeDrawController controller) {
        return Transform(
          transform: Matrix4.identity()
            ..translate(
              controller.curCanvasOffset.value.dx,
              controller.curCanvasOffset.value.dy,
            )
            ..scale(controller.curCanvasScale.value),
          child: Stack(children: [
            buildAllPaths(),
            buildCurrentPath(),
          ]),
        );
      },
    );
  }

  /// 绘制当前笔画
  Widget buildCurrentPath() {
    final freeDrawController = Get.find<FreeDrawController>();
    return RepaintBoundary(
      child: CustomPaint(
        isComplex: true,
        painter: Sketcher(freeDrawController.currentStroke.value.isEmpty
            ? []
            : [freeDrawController.currentStroke.value]),
      ),
    );
  }

  /// 绘制所有笔画
  Widget buildAllPaths() {
    final freeDrawController = Get.find<FreeDrawController>();
    return RepaintBoundary(
      child: CustomPaint(
        isComplex: true,
        painter: Sketcher(
          freeDrawController.strokes.value,
        ),
      ),
    );
  }
}

class Sketcher extends CustomPainter {
  final List<Stroke> propStrokes; // 用List表示一笔或者多笔，
  Sketcher(this.propStrokes);

  @override
  void paint(Canvas canvas, Size size) {
    for (var stroke in propStrokes) {
      if (stroke.path == null) continue;
      canvas.drawPath(stroke.path!, stroke.paint);
    }
  }

  @override
  bool shouldRepaint(Sketcher oldDelegate) {
    return true;
  }
}
