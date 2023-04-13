import 'dart:ui' as ui;

import 'package:flutter_application_2/type/elementType/white_element.dart';

enum ElementType {
  stroke,
  geometricShape,
}


class ElementContainer<T extends WhiteElement> {
  ElementType type;
  T element;

  ElementContainer({required this.type, required this.element});
}
