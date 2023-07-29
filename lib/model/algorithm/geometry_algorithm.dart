import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter_application_2/model/algorithm/curvature_collection.dart';
import 'package:vector_math/vector_math.dart';
import 'package:flutter_application_2/model/extension/path_extension.dart';

class GeometryAlgorithm {
  /// 获取坐标点集合的曲率构成曲率集合
  List<CurvatureCollection> getCurvatureCollectionList(
      List<ui.Offset> offsets) {
    List<CurvatureCollection> curvatureCollectionList = [];
    // 如果首尾不闭合则首点和尾点的曲率为0
    // 如果首尾闭合，则进行如下计算
    for (var i = 1; i < offsets.length - 1; i++) {
      var curvatureCollection = GeometryAlgorithm.getCurvature(
          offsets[i - 1], offsets[i], offsets[i + 1]);
      curvatureCollectionList
          .add(CurvatureCollection(curvatureCollection, offsets[i]));
    }
    if (offsets.first == offsets.last) {
      var intersectCurvatureCollection = GeometryAlgorithm.getCurvature(
          offsets[offsets.length - 2], offsets.first, offsets[1]);
      curvatureCollectionList.insert(
          0, CurvatureCollection(intersectCurvatureCollection, offsets.first));
      curvatureCollectionList
          .add(CurvatureCollection(intersectCurvatureCollection, offsets.last));
    } else {
      var headCurvatureCollection = CurvatureCollection(0, offsets.first);
      var endCurvatureCollection = CurvatureCollection(0, offsets.last);
      curvatureCollectionList.insert(0, headCurvatureCollection);
      curvatureCollectionList.add(endCurvatureCollection);
    }
    return curvatureCollectionList;
  }

  /// 获取某点的曲率
  static num getCurvature(
      ui.Offset prePoint, ui.Offset curPoint, ui.Offset nextPoint) {
    ui.Offset preOffset = curPoint - prePoint;
    Vector2 preVector = Vector2(preOffset.dx, preOffset.dy);
    Vector2 preNomalizedVector = preVector / preVector.length;
    ui.Offset nextOffset = nextPoint - curPoint;
    Vector2 nextVector = Vector2(nextOffset.dx, nextOffset.dy);
    Vector2 nextNomalizedVector = nextVector / nextVector.length;
    return (nextNomalizedVector - preNomalizedVector).length;
  }

  /// 生成贝塞尔曲线
  static ui.Path getBezierPath(List<ui.Offset> offsets) {
    if (offsets.length < 2) {
      // 抛出错误长度过小
      throw Exception("offsets长度过小");
    }
    var path = ui.Path();
    path.moveTo(offsets[0].dx, offsets[0].dy);
    for (int i = 1; i < offsets.length - 1; ++i) {
      final p0 = offsets[i];
      final p1 = offsets[i + 1];
      path.quadraticBezierTo(
          p0.dx, p0.dy, (p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
    }
    return path;
  }

  /// 判断线段是否相交
  static bool isSegmentsIntersect(
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

  /// 获取相交点
  static getIntersectionPoint(List<ui.Offset> offsets) {
    List<ui.Offset> intersectionPoint = [];
    for (var i = 0; i < offsets.length - 3; i++) {
      var curWindow = [offsets[i], offsets[i + 1]];
      for (var j = i + 3; j < offsets.length - 1; j++) {
        var compareWindow = [offsets[j], offsets[j + 1]];
        if (GeometryAlgorithm.isSegmentsIntersect(
            curWindow[0], curWindow[1], compareWindow[0], compareWindow[1])) {
          intersectionPoint.add(offsets[i]);
          intersectionPoint.add(offsets[j]);
        }
      }
    }
    return intersectionPoint;
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
        if (isSegmentsIntersect(originPoints[i], originPoints[i + 1],
            targetPoints[j], targetPoints[j + 1])) {
          return true;
        }
      }
    }
    return false;
  }

  /// 判断单个path是否自身有相交
}

