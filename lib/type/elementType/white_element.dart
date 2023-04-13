import 'dart:ui';

abstract class WhiteElement {
  Path get path;

  /// 判断是否为空
  bool get isEmpty;

  /// 拖拽偏移量
  setDragOffset(Offset delta);
}
