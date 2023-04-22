import 'package:flutter/material.dart';
import 'package:flutter_application_2/model/white_board_manager.dart';
import 'package:get/get.dart';

/// 工具条Widget
class ToolBar extends StatefulWidget {
  const ToolBar({super.key});

  @override
  State<ToolBar> createState() => _ToolBarWidgetState();
}

class _ToolBarWidgetState extends State<ToolBar>
    with SingleTickerProviderStateMixin {
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
        whiteBoardManager.setCurrentToolType(ActionType.freeDraw);
      },
    );
  }

  /// 拖拽icon
  Widget _translateCanvasWidget() {
    return IconButton(
      icon: const Icon(Icons.pan_tool),
      onPressed: () {
        whiteBoardManager.setCurrentToolType(ActionType.transform);
      },
    );
  }

  // 橡皮擦icon
  Widget _eraseWidget() {
    return IconButton(
      icon: const Icon(Icons.phonelink_erase),
      onPressed: () {
        whiteBoardManager.setCurrentToolType(ActionType.eraser);
      },
    );
  }

  /// 套索icon
  Widget _lassoWidget() {
    return IconButton(
      icon: const Icon(Icons.crop_square),
      onPressed: () {
        whiteBoardManager.setCurrentToolType(ActionType.lasso);
      },
    );
  }
}
