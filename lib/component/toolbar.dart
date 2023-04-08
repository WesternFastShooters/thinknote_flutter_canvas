import 'package:flutter/material.dart';
import 'package:flutter_application_2/modal/white_board_manager.dart';
import 'package:get/get.dart';

/// 工具条Widget
class ToolBar extends StatefulWidget {
  const ToolBar({super.key});

  @override
  State<ToolBar> createState() => _ToolBarWidgetState();
}

class _ToolBarWidgetState extends State<ToolBar>
    with SingleTickerProviderStateMixin {
  // final whiteBoardBase = Get.find<WhiteBoardBase>();
  final WhiteBoardManager whiteBoardManager = Get.find<WhiteBoardManager>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WhiteBoardManager>(
      builder: (whiteBoardManager) {
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
        whiteBoardManager.currentToolType = ToolType.freeDraw;
      },
    );
  }

  /// 拖拽icon
  Widget _translateCanvasWidget() {
    return IconButton(
      icon: const Icon(Icons.pan_tool),
      onPressed: () {
        whiteBoardManager.currentToolType = ToolType.transform;
      },
    );
  }

  // 橡皮擦icon
  Widget _eraseWidget() {
    return IconButton(
      icon: const Icon(Icons.phonelink_erase),
      onPressed: () {
        whiteBoardManager.currentToolType = ToolType.eraser;
      },
    );
  }

  /// 套索icon
  Widget _lassoWidget() {
    return IconButton(
      icon: const Icon(Icons.crop_square),
      onPressed: () {
        whiteBoardManager.currentToolType = ToolType.lasso;
      },
    );
  }
}
