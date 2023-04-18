import 'dart:ui';

/// 图形类型
enum ElementType {
  stroke,
  geometricShape,
}

/// 移动元素的模式
enum MoveElementMode {
  /// 拖动
  drag,

  /// 瞬移
  teleport,
}


abstract class WhiteBoardElement {
  ElementType get elementType;
  set elementType(ElementType type);

  /// 图形对应的path
  Path get path;
  set path(Path path);

  /// 判断是否为空
  bool get isEmpty;

  Offset get dragOffset;
  set dragOffset(Offset delta);

  /// 深拷贝
  WhiteBoardElement deepCopy();

  /// 移动元素
  translateElement({required Offset offset, required MoveElementMode mode});
}
