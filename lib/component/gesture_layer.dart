import 'package:flutter/widgets.dart';
import 'package:flutter_application_2/model/graphics_canvas.dart';
import 'package:get/get.dart';

class GestureLayer extends StatelessWidget {
  GestureLayer({super.key});

  @override
  Widget build(BuildContext context) {
    /// 指头编号
    int currentPointerId = -1;
    return GetBuilder<GraphicsCanvas>(
      builder: (graphicsCanvas) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onScaleStart: graphicsCanvas.onScaleStart,
            onScaleUpdate: graphicsCanvas.onScaleUpdate,
            onScaleEnd: graphicsCanvas.onScaleEnd,
            onDoubleTapDown: graphicsCanvas.onDoubleTapDown,
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerDown: (event) {
                if (currentPointerId != -1) {
                  return;
                }
                currentPointerId = event.pointer;
                graphicsCanvas.onPointerDown(event);
              },
              onPointerMove: (event) {
                if (event.pointer != currentPointerId) {
                  return;
                }
                graphicsCanvas.onPointerMove(event);
              },
              onPointerUp: (event) {
                if (event.pointer != currentPointerId) {
                  return;
                }
                currentPointerId = -1;
                graphicsCanvas.onPointerUp(event);
              },
            ),
          ),
        );
      },
    );
  }
}
