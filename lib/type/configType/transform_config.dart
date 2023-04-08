import 'dart:ui';

import 'package:flutter/gestures.dart';

class TransformConfig {
  TransformConfig();

  // 最小缩放
  double minCanvasScale = 0.1;

  // 最大缩放
  double maxCanvasScale = 3.0;

  // 画布上一次的缩放比例
  double preCanvasScale = 1.0;

  // 画布当前的偏移量
  Offset curCanvasOffset = Offset.zero;

  // 画布当前的缩放比例
  double curCanvasScale = 1.0;

  // 可视区域的大小
  Size visibleAreaSize = Size.zero;

  // 可视区域的中心
  Offset visibleAreaCenter = Offset.zero;

  // 用来计算双指缩放是缩小还是放大
  ScaleUpdateDetails? lastScaleUpdateDetails;
}
