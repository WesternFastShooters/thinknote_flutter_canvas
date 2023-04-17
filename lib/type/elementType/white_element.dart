import 'dart:ui';

abstract class WhiteElement {
  /// 图形对应的path
  Path? path;

  /// 判断是否为空
  bool get isEmpty;

  /// 深拷贝
  deepCopy();
}
