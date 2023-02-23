import 'dart:ui';

class AlgorithmUtil {
  AlgorithmUtil.internal();

  /// 以屏幕上任意一点为中心进行缩放、实时计算画布新增偏移量的算法
  ///
  /// [center]: 缩放中心
  /// [curCanvasOffset]: 画布当前的偏移量
  /// [curCanvasScale]: 画布当前的缩放比例
  /// [preCanvasScale]: 画布上一次的缩放比例
  ///
  /// return: 这一次缩放导致画布新增的偏移量
  static Offset centerZoomAlgorithm({
    required Offset center,
    required Offset curCanvasOffset,
    required double curCanvasScale,
    required double preCanvasScale,
  }) {
    double thisTimeCanvasOffsetX = -(center.dx - curCanvasOffset.dx) *
        (curCanvasScale - preCanvasScale) /
        preCanvasScale;
    double thisTimeCanvasOffsetY = -(center.dy - curCanvasOffset.dy) *
        (curCanvasScale - preCanvasScale) /
        preCanvasScale;
    Offset thisTimeCanvasOffset =
        Offset(thisTimeCanvasOffsetX, thisTimeCanvasOffsetY);
    return thisTimeCanvasOffset;
  }
}

