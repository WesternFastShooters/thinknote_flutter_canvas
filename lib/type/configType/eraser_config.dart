import 'dart:ui';

class EraserConfig {

  // 构造函数
  EraserConfig({
    required this.currentEraserPosition,
    required this.eraserRadius,
  });

  /// 当前橡皮擦的位置
  Offset? currentEraserPosition;

  /// 橡皮擦的半径
  double eraserRadius = 10.0;

  /// 橡皮擦的Path
  Path get eraserPath => Path()
    ..addOval(Rect.fromCircle(
        center: currentEraserPosition!,
        radius: eraserRadius));
  
  /// 配置重置
  reset(){
    currentEraserPosition = null;
    eraserRadius = 10.0;
  }
}
