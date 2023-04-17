import 'dart:ui';
import 'package:flutter_application_2/modal/utils/geometry_tool.dart';
import '../white_board_manager.dart';

extension EraserFunction on WhiteBoardConfig {
  /// 设置当前橡皮擦位置
  setCurrentEraserPosition(Offset position) {
    currentEraserPosition = transformToCanvasPoint(position);
  }

  /// 擦除
  erase() {
    if (currentEraserPosition == null) return;

    canvasElementList.removeWhere((item) {
      return isIntersecting(
          originPath: eraserPath, targetPath: item.element.path);
    });
  }
}
