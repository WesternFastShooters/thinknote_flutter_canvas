
enum WhiteBoardElementType {
  stroke,
  geometricShape,
}


class WhiteBoardElement<T> {
  WhiteBoardElementType type;
  T element;

  WhiteBoardElement({required this.type, required this.element});

  /// 实例对象深拷贝
  WhiteBoardElement<T> copy() {
    return WhiteBoardElement<T>(
      type: this.type,
      element: this.element,
    );
  }
}
