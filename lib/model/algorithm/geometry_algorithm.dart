import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter_application_2/model/extension/path_extension.dart';

class GeometryAlgorithm {
  /// 判断线段是否相交
  static bool _isSegmentsIntersect(
      ui.Offset a, ui.Offset b, ui.Offset c, ui.Offset d) {
    num cross(ui.Offset p1, ui.Offset p2) => p1.dx * p2.dy - p1.dy * p2.dx;

    if (max(c.dx, d.dx) < min(a.dx, b.dx) ||
        max(a.dx, b.dx) < min(c.dx, d.dx) ||
        max(c.dy, d.dy) < min(a.dy, b.dy) ||
        max(a.dy, b.dy) < min(c.dy, d.dy)) {
      return false;
    }

    if (cross(a - d, c - d) * cross(b - d, c - d) > 0 ||
        cross(d - b, a - b) * cross(c - b, a - b) > 0) {
      return false;
    }
    return true;
  }

  /// 判断闭合图形Path是否与其他path是否重叠
  static bool isClosePathOverlay(
      {required ui.Path originPath, required ui.Path targetPath}) {
    if (originPath.getBounds().isEmpty) {
      return false;
    }

    ui.Rect outerRect = originPath.getBounds();
    ui.Rect innerRect = targetPath.getBounds();
    if (!outerRect.overlaps(innerRect)) {
      return false;
    }

    List<ui.Offset> points = targetPath.toBePoints();

    for (ui.Offset point in points) {
      if (originPath.contains(point)) {
        return true;
      }
    }

    return false;
  }

  /// 判断两个Path是否相交
  static bool isPathIntersection(
      {required ui.Path originPath, required ui.Path targetPath}) {
    List<ui.Offset> originPoints = originPath.toBePoints();
    List<ui.Offset> targetPoints = targetPath.toBePoints();

    for (int i = 0; i < originPoints.length - 1; i++) {
      for (int j = 0; j < targetPoints.length - 1; j++) {
        if (_isSegmentsIntersect(originPoints[i], originPoints[i + 1],
            targetPoints[j], targetPoints[j + 1])) {
          return true;
        }
      }
    }
    return false;
  }

  /// 判断单个path是否自身有相交
}
