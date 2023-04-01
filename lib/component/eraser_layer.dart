import 'package:flutter/material.dart';
import 'package:flutter_application_2/modal/eraser_logic.dart';
import 'package:flutter_application_2/modal/transform_logic.dart';
import 'package:get/get.dart';

class EraserController extends GetxController {
  final transformLogic = Get.find<TransformLogic>();
  final eraseLogic = Get.find<EraserLogic>();

  Rx<Offset> get curCanvasOffset => transformLogic.curCanvasOffset;
  Rx<double> get curCanvasScale => transformLogic.curCanvasScale;
  Rx<Offset?> get currentEraserPosition => eraseLogic.currentEraserPosition;
  RxDouble get eraserRadius => eraseLogic.eraserRadius;

  @override
  void onInit() {
    super.onInit();
    everAll(
        [curCanvasOffset, curCanvasScale, currentEraserPosition, eraserRadius],
        (calback) {
      update();
    });
  }
}

class EraserLayer extends StatelessWidget {
  final eraseLogic = Get.find<EraserLogic>();
  final transformLogic = Get.find<TransformLogic>();
  EraserLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<EraserController>(
      init: EraserController(),
      builder: (eraserController) {
        return Transform(
          transform: Matrix4.identity()
            ..translate(
              eraserController.curCanvasOffset.value.dx,
              eraserController.curCanvasOffset.value.dy,
            )
            ..scale(eraserController.curCanvasScale.value),
          child: RepaintBoundary(
            child: CustomPaint(
              isComplex: true,
              painter: Eraser(
                  eraserLocation: eraserController.currentEraserPosition.value),
            ),
          ),
        );
      },
    );
  }
}

class Eraser extends CustomPainter {
  final eraserController = Get.find<EraserController>();
  final transformLogicModal = Get.find<TransformLogic>();

  late Offset? eraserLocation;

  // 构造函数
  Eraser({this.eraserLocation});

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制一个半径为10的圆形，颜色为蓝色
    if (eraserLocation != null) {
      canvas.drawCircle(
          transformLogicModal.transformToCanvasPoint(eraserLocation!),
          eraserController.eraserRadius.value,
          Paint()..color = Colors.blue);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
