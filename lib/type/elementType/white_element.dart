import 'dart:ui';

abstract class WhiteElement {

  /// 图形对应的path
  Path get path;

  /// 判断是否为空
  bool get isEmpty;

  /// 拖拽偏移量
  Offset get dragOffset;
  set dragOffset(Offset offset);

  /// 设置偏移量
  setDragOffset(Offset delta);

  /// 深拷贝
  deepCopy();
}
