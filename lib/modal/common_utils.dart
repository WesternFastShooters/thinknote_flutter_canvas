import 'dart:ui' as ui;
import 'package:flutter/gestures.dart';
import 'package:flutter_application_2/modal/white_board_manager.dart';

extension CommonUtils on WhiteBoardManager {
  /// 根据传入的坐标映射为canvas的坐标
  Offset transformToCanvasPoint(Offset position) =>
      ((position - transformConfig.curCanvasOffset) /
          transformConfig.curCanvasScale);

  /// 判断两个Path是否相交
  bool isIntersecting(
      {required ui.Path originPath, required ui.Path? targetPath}) {
    if (targetPath == null) {
      return false;
    }

    // 1.判断如果targetPath的boundingBox和eraserPath的boundingBox不重合，则一定不相交
    ui.Rect outerRect = originPath.getBounds();
    ui.Rect innerRect = targetPath.getBounds();
    if (!outerRect.overlaps(innerRect)) {
      return false;
    }

    // 2.如果eraserPath的boundingBox包裹了targetPath的boundingBox，则采取如下判断
    // 2.1.computeMetrics()方法获取targetPath曲线上的点
    // 2.2.遍历点，判断是否在eraserPath内
    // 2.3.如果有一个点在eraserPath内，则认为相交
    // 2.4.如果所有点都不在eraserPath内，则认为不相交
    List<Offset> points = [];
    ui.PathMetrics targetPathMetrics = targetPath.computeMetrics();
    for (ui.PathMetric pathMetric in targetPathMetrics) {
      // pathMetric为targetPath中的线段
      for (double i = 0; i < pathMetric.length; i++) {
        ui.Tangent? tangent =
            pathMetric.getTangentForOffset(i); // 获取到线段上长度为i时的切线
        points.add(tangent!.position); // 获取到切线对应的位置
      }
    }
    for (Offset point in points) {
      if (originPath.contains(point)) {
        return true;
      }
    }

    return false;
  }
}
