import 'dart:ui';

import 'package:flutter/gestures.dart';

class TransformConfig {
  TransformConfig();

  // 最小缩放
  double globalMinCanvasScale = 1.0;

  // 最大缩放
  double globalMaxCanvasScale = 3.0;

  // 画布上一次的缩放比例
  double globalPreCanvasScale = 1.0;

  // 画布的偏移量
  Offset globalCanvasOffset = Offset.zero;

  // 画布当前的缩放比例
  double globalCanvasScale = 1.0;

  // 可视区域的大小
  Size visibleAreaSize = Size.zero;

  // 可视区域的中心
  Offset visibleAreaCenter = Offset.zero;

  // 用来计算双指缩放是缩小还是放大
  ScaleUpdateDetails? lastScaleUpdateDetails;
}
