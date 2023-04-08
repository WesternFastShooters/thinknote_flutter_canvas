
enum ElementType {
  stroke,
  geometricShape,
}


class ElementContainer<T> {
  ElementType type;
  T element;

  ElementContainer({required this.type, required this.element});

  /// 实例对象深拷贝
  ElementContainer<T> copy() {
    return ElementContainer<T>(
      type: this.type,
      element: this.element,
    );
  }
}
