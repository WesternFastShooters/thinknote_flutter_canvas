import 'package:flutter/material.dart';
import 'package:flutter_application_2/constants/tool_type.dart';
import 'package:flutter_application_2/modal/board_modal.dart';
import 'package:get/get.dart';

/// 工具条Widget
class ToolBar extends StatefulWidget {
  const ToolBar({super.key});

  @override
  State<ToolBar> createState() => _ToolBarWidgetState();
}

class _ToolBarWidgetState extends State<ToolBar>
    with SingleTickerProviderStateMixin {
  final BoardModal boardModal = Get.find<BoardModal>();

  late AnimationController _animationController;
  late CurvedAnimation _curvedAnimation;
  late Tween<double> _scaleTween;
  late Animation _scaleAnimation;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BoardModal>(
      builder: (_) {
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
        boardModal.currentToolType = ToolType.freeDraw;
      },
    );
  }

  /// 拖拽icon
  Widget _translateCanvasWidget() {
    return IconButton(
      icon: const Icon(Icons.pan_tool),
      onPressed: () {
        boardModal.currentToolType = ToolType.drag;
      },
    );
  }

  // 橡皮擦icon
  Widget _eraseWidget() {
    return IconButton(
      icon: const Icon(Icons.phonelink_erase),
      onPressed: () {
        boardModal.currentToolType = ToolType.eraser;
      },
    );
  }

  /// 套索icon
  Widget _lassoWidget() {
    return IconButton(
      icon: const Icon(Icons.crop_square),
      onPressed: () {
        boardModal.currentToolType = ToolType.lasso;
      },
    );
  }
}
