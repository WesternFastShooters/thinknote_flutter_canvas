import 'package:flutter/material.dart';
import 'package:flutter_application_2/model/graphics_canvas.dart';
import 'package:flutter_application_2/model/store/canvas_store.dart';
import 'package:get/get.dart';

/// 工具条Widget
class ToolBar extends StatefulWidget {
  const ToolBar({super.key});

  @override
  State<ToolBar> createState() => _ToolBarWidgetState();
}

class _ToolBarWidgetState extends State<ToolBar>
    with SingleTickerProviderStateMixin {
  final GraphicsCanvas graphicsCanvas = Get.find<GraphicsCanvas>();


  @override
  Widget build(BuildContext context) {
    return GetBuilder<GraphicsCanvas>(
      builder: (graphicsCanvas) {
        return Row(
          children: [
            _drawPencilWidget(),
            _eraseWidget(),
            _lassoWidget(),
            _translateCanvasWidget(),
          ],
        );
      },
    );
  }

  /// 自由绘画icon
  Widget _drawPencilWidget() {
    return IconButton(
      icon: const Icon(Icons.brush),
      onPressed: () {
        graphicsCanvas.switchTool(ActionType.freeDraw);
        
      },
    );
  }

  /// 拖拽icon
  Widget _translateCanvasWidget() {
    return IconButton(
      icon: const Icon(Icons.pan_tool),
      onPressed: () {
        graphicsCanvas.switchTool(ActionType.hand);
      },
    );
  }

  // 橡皮擦icon
  Widget _eraseWidget() {
    return IconButton(
      icon: const Icon(Icons.phonelink_erase),
      onPressed: () {
        graphicsCanvas.switchTool(ActionType.eraser);
      },
    );
  }

  /// 套索icon
  Widget _lassoWidget() {
    return IconButton(
      icon: const Icon(Icons.crop_square),
      onPressed: () {
        graphicsCanvas.switchTool(ActionType.lasso);
      },
    );
  }
}
