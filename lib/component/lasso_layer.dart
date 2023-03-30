import 'package:flutter/material.dart';
import 'package:flutter_application_2/modal/board_modal.dart';
import 'package:get/get.dart';
import 'package:dash_painter/dash_painter.dart';

class LassoLayer extends StatelessWidget {
  const LassoLayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      closeLassoScale(),
      drawingCurrentLassoPath(),
    ]);
  }
}

/// 绘制当前正在绘制的套索虚线
Widget drawingCurrentLassoPath() {
  return GetBuilder<BoardModal>(builder: (BoardModal boardModal) {
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
          painter: LassoDashedLine(),
        ),
      ),
    );
  });
}

/// 套索虚线canvas
class LassoDashedLine extends CustomPainter {
  final BoardModal boardModal = Get.find<BoardModal>();

  // 构造函数
  LassoDashedLine();

  @override
  void paint(Canvas canvas, Size size) {
    // 消费boardModal中的currentLassoPoints绘制虚线path
    if (boardModal.currentLassoPoints.length > 1) {
      final Paint paint = Paint()
        ..color = Colors.blue
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..isAntiAlias = true
        ..strokeJoin = StrokeJoin.miter;

      final Path path = Path();
      path.moveTo(boardModal.currentLassoPoints[0].dx,
          boardModal.currentLassoPoints[0].dy);
      for (int i = 1; i < boardModal.currentLassoPoints.length; i++) {
        path.lineTo(boardModal.currentLassoPoints[i].dx,
            boardModal.currentLassoPoints[i].dy);
      }
      const DashPainter(span: 4, step: 9).paint(canvas, path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

/// 由套索虚线生成闭合套索范围
Widget closeLassoScale() {
  return GetBuilder<BoardModal>(builder: (BoardModal boardModal) {
    return RepaintBoundary(
      child: CustomPaint(
        isComplex: true,
        painter: ClosedShapePolygon(),
      ),
    );
  });
}

/// 闭合套索范围canvas
class ClosedShapePolygon extends CustomPainter {
  final BoardModal boardModal = Get.find<BoardModal>();
  ClosedShapePolygon();

  @override
  void paint(Canvas canvas, Size size) {
    // 通过boardModal中的closedShapePolygonPoints生成一个闭合的多边形
    if (boardModal.closedShapePolygonPoints.length > 1) {
      final Paint paint = Paint()
        ..color = Colors.blue
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..isAntiAlias = true
        ..strokeJoin = StrokeJoin.miter;

      final Path path = Path();
      path.moveTo(boardModal.closedShapePolygonPoints[0].dx,
          boardModal.closedShapePolygonPoints[0].dy);
      for (int i = 1; i < boardModal.closedShapePolygonPoints.length; i++) {
        path.lineTo(boardModal.closedShapePolygonPoints[i].dx,
            boardModal.closedShapePolygonPoints[i].dy);
      }
      path.close();
      const DashPainter(span: 4, step: 9).paint(canvas, path, paint);
      // 清空boardModal中的closedShapePolygonPoints数据
      boardModal.closedShapePolygonPoints.clear();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
