import 'dart:ui';
import 'package:flutter_application_2/modal/utils/geometry_tool.dart';
import '../white_board_manager.dart';

extension EraserFunction on WhiteBoardManager {
  /// 设置当前橡皮擦位置
  setCurrentEraserPosition(Offset position) {
    whiteBoardConfig.currentEraserPosition = transformToCanvasPoint(position);
  }

  /// 擦除
  erase() {
    if (whiteBoardConfig.currentEraserPosition == null) return;

    whiteBoardConfig.canvasElementList.removeWhere((item) {
      return isIntersecting(
          originPath: whiteBoardConfig.eraserPath, targetPath: item.path);
    });
  }

  /// 重置橡皮擦配置
  resetEraserConfig() {
    whiteBoardConfig.currentEraserPosition = null;
    whiteBoardConfig.eraserRadius = 10.0;
  }
}
