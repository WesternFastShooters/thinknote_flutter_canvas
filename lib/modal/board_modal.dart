import 'dart:ui';
import 'package:get/get.dart';

class BoardModal extends GetxController {
  // 画布当前的偏移量
  Offset curCanvasOffset = Offset.zero;

  // 可视区域的大小
  Size visibleAreaSize = Size.zero;

  // 可视区域的中心
  Offset visibleAreaCenter = Offset.zero;
}
