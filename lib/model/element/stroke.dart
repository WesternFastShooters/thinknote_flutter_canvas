import 'dart:ui' as ui;
import 'package:flutter/gestures.dart';

class Stroke {
  Stroke({
    required this.path,
    required this.paint,
  });

  ui.Path path;
  ui.Paint paint;
  translate(ui.Offset offset) {
    final matrix4 = Matrix4.identity()..translate(offset.dx, offset.dy);
    path = path.transform(matrix4.storage);
  }

  Stroke copy() {
    return Stroke(path: ui.Path.from(path), paint: paint);
  }
}
