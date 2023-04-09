import 'dart:ui';

import 'package:flutter_application_2/type/elementType/element_container.dart';

class LassoConfig {
  /// 套索的路径点
  List<Offset> lassoPathPoints = [];

  /// 处于套索范围中的元素
  List<ElementContainer> selectedElementList = [];
  
}