import 'dart:ui';

class EraserConfig {

  /// 当前橡皮擦的位置
  Offset? currentEraserPosition;

  /// 橡皮擦的半径
  double eraserRadius = 10.0;

  /// 橡皮擦的Path
  Path get eraserPath => Path()
    ..addOval(Rect.fromCircle(
        center: currentEraserPosition!,
        radius: eraserRadius));
  
 /// 重置橡皮擦配置
  resetEraserConfig() {
    currentEraserPosition = null;
    eraserRadius = 10.0;
  }

}
