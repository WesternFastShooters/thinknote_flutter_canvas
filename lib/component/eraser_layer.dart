import 'package:flutter/material.dart';
import 'package:flutter_application_2/modal/eraser_logic.dart';
import 'package:flutter_application_2/modal/transform_logic.dart';
import 'package:get/get.dart';

// class CombineModelForEraser extends GetxController {
//   final transformLogic = Get.find<TransformLogic>();
//   final eraseLogic = Get.find<EraserLogic>();
//   CombineModelForEraser();
// }

class EraserLayer extends StatelessWidget {
  final eraseLogic = Get.find<EraserLogic>();
  final transformLogic = Get.find<TransformLogic>();
  EraserLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..translate(
          transformLogic.curCanvasOffset.dx,
          transformLogic.curCanvasOffset.dy,
        )
        ..scale(transformLogic.curCanvasScale),
      child: RepaintBoundary(
        child: CustomPaint(
          isComplex: true,
          painter: Eraser(eraserLocation: eraseLogic.currentEraserPosition),
        ),
      ),
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
    //       child: RepaintBoundary(
    //         child: CustomPaint(
    //           isComplex: true,
    //           painter: Eraser(
    //               eraserLocation: eraseLogic.currentEraserPosition),
    //         ),
    //       ),
    //     );
    //   },
    // );
  }
}

class Eraser extends CustomPainter {
  final eraseLogic = Get.find<EraserLogic>();

  late Offset? eraserLocation;

  // 构造函数
  Eraser({this.eraserLocation});

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制一个半径为10的圆形，颜色为蓝色
    if (eraserLocation != null) {
      canvas.drawCircle(eraserLocation!, eraseLogic.eraserRadius,
          Paint()..color = Colors.blue);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
