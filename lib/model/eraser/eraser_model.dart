import 'dart:ui';

import 'package:flutter_application_2/model/white_board_manager.dart';

mixin EraserModel on WhiteBoardGeometry, WhiteBoardInfo {
  /// 当前橡皮擦的位置
  Offset? currentEraserPosition;

  /// 设置当前橡皮擦位置
  setCurrentEraserPosition(Offset position) {
    currentEraserPosition = transformToCanvasPoint(position);
  }

  /// 橡皮擦的半径
  double eraserRadius = 10.0;

  /// 橡皮擦的Path
  Path get eraserPath => Path()
    ..addOval(
        Rect.fromCircle(center: currentEraserPosition!, radius: eraserRadius));

  /// 擦除
  erase() {
    if (currentEraserPosition == null) return;
    canvasElementList.removeWhere((item) {
      return isIntersecting(originPath: eraserPath, targetPath: item.path);
    });
  }

  /// 重置橡皮擦配置
  resetEraserConfig() {
    currentEraserPosition = null;
    eraserRadius = 10.0;
  }
}
