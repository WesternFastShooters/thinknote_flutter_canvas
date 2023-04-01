import 'package:flutter/material.dart';
import 'package:flutter_application_2/modal/lasso_logic.dart';
import 'package:flutter_application_2/modal/transform_logic.dart';
import 'package:get/get.dart';
import 'package:dash_painter/dash_painter.dart';

class LassoController extends GetxController {
  final lassoLogic = Get.find<LassoLogic>();
  final transformLogic = Get.find<TransformLogic>();

  Rx<Offset> get curCanvasOffset => transformLogic.curCanvasOffset;
  Rx<double> get curCanvasScale => transformLogic.curCanvasScale;
// currentLassoPoints
// closedShapePolygonPoints
  RxList<Offset> get currentLassoPoints => lassoLogic.currentLassoPoints;
  RxList<Offset> get closedShapePolygonPoints =>
      lassoLogic.closedShapePolygonPoints;

  @override
  void onInit() {
    everAll([
      curCanvasOffset,
      curCanvasScale,
      currentLassoPoints,
      closedShapePolygonPoints,
    ], (callback) => update([]));
    super.onInit();
  }
}

class LassoLayer extends StatelessWidget {
  final transformLogic = Get.find<TransformLogic>();

  LassoLayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      id:'lasso',
      init:LassoController(),
      builder: (LassoController lassoController) {
        return Transform(
          transform: Matrix4.identity()
            ..translate(
              lassoController.curCanvasOffset.value.dx,
              lassoController.curCanvasOffset.value.dy,
            )
            ..scale(lassoController.curCanvasScale.value),
          child: Stack(children: [
            closeLassoScale(),
            drawingCurrentLassoPath(),
          ]),
        );
      },
    );
  }

  /// 绘制当前正在绘制的套索虚线
  Widget drawingCurrentLassoPath() {
    return RepaintBoundary(
      child: CustomPaint(
        isComplex: true,
        painter: LassoDashedLine(),
      ),
    );
  }

  /// 由套索虚线生成闭合套索范围
  Widget closeLassoScale() {
    return RepaintBoundary(
      child: CustomPaint(
        isComplex: true,
        painter: ClosedShapePolygon(),
      ),
    );
  }
}

/// 套索虚线canvas
class LassoDashedLine extends CustomPainter {
  final lassoController = Get.find<LassoController>();
  LassoDashedLine();

  @override
  void paint(Canvas canvas, Size size) {
    // 消费boardModal中的currentLassoPoints绘制虚线path
    if (lassoController.currentLassoPoints.length > 1) {
      final Paint paint = Paint()
        ..color = Colors.blue
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..isAntiAlias = true
        ..strokeJoin = StrokeJoin.miter;

      final Path path = Path();
      path.moveTo(lassoController.currentLassoPoints[0].dx,
          lassoController.currentLassoPoints[0].dy);
      for (int i = 1; i < lassoController.currentLassoPoints.length; i++) {
        path.lineTo(lassoController.currentLassoPoints[i].dx,
            lassoController.currentLassoPoints[i].dy);
      }
      const DashPainter(span: 4, step: 9).paint(canvas, path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

/// 闭合套索范围canvas
class ClosedShapePolygon extends CustomPainter {
  final lassoLogic = Get.find<LassoLogic>();
  ClosedShapePolygon();

  @override
  void paint(Canvas canvas, Size size) {
    // 通过boardModal中的closedShapePolygonPoints生成一个闭合的多边形
    if (lassoLogic.closedShapePolygonPoints.length > 1) {
      final Paint paint = Paint()
        ..color = Colors.blue
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..isAntiAlias = true
        ..strokeJoin = StrokeJoin.miter;

      final Path path = Path();
      path.moveTo(lassoLogic.closedShapePolygonPoints[0].dx,
          lassoLogic.closedShapePolygonPoints[0].dy);
      for (int i = 1; i < lassoLogic.closedShapePolygonPoints.length; i++) {
        path.lineTo(lassoLogic.closedShapePolygonPoints[i].dx,
            lassoLogic.closedShapePolygonPoints[i].dy);
      }
      path.close();
      const DashPainter(span: 4, step: 9).paint(canvas, path, paint);
      // 清空boardModal中的closedShapePolygonPoints数据
      lassoLogic.closedShapePolygonPoints.clear();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
