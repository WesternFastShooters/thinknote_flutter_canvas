import 'package:flutter/material.dart';
import 'package:flutter_application_2/modal/logic/area_logic.dart';
import 'package:flutter_application_2/modal/board_modal.dart';
import 'package:get/get.dart';

class BackgroundLayerWidget extends StatelessWidget {
  const BackgroundLayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BoardModal>(
      builder: (BoardModal boardModal) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onScaleStart: (ScaleStartDetails details) {
              boardModal.onScaleStart(details);
            },
            onScaleUpdate: (ScaleUpdateDetails details) {
              boardModal.onScaleUpdate(details);
            },
            onScaleEnd: (ScaleEndDetails details) {
              boardModal.onScaleEnd(details);
            },
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerMove: (PointerMoveEvent event) {
                boardModal.execPointerMoveForTranslate(event);
              },
              onPointerUp: (PointerUpEvent e) {
                boardModal.execPointerUpForTranslate(e);
              },
              child: Transform(
                transform: Matrix4.identity()
                  ..translate(
                    boardModal.curCanvasOffset.dx,
                    boardModal.curCanvasOffset.dy,
                  )
                  ..scale(boardModal.curCanvasScale),
                child: RepaintBoundary(
                  child: CustomPaint(
                    isComplex: true,
                    painter: _BackgroundLayerWidget(),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BackgroundLayerWidget extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
