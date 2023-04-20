import 'dart:ui';

import '../white_board_manager.dart';

extension GeometryTool on WhiteBoardManager {
  /// 根据传入的坐标映射为canvas的坐标
  Offset transformToCanvasPoint(
    currentPosition,
  ) =>
      ((currentPosition - whiteBoardConfig.globalCanvasOffset) /
          whiteBoardConfig.globalCanvasScale);

  /// 判断两个Path是否相交
  bool isIntersecting({required Path originPath, required Path? targetPath}) {
    if (targetPath == null) {
      return false;
    }

    // 1.判断如果targetPath的boundingBox和originPath的boundingBox不重合，则一定不相交
    Rect outerRect = originPath.getBounds();
    Rect innerRect = targetPath.getBounds();
    if (!outerRect.overlaps(innerRect)) {
      return false;
    }

    // 2.如果originPath的boundingBox包裹了targetPath的boundingBox，则采取如下判断
    // 2.1.computeMetrics()方法获取targetPath曲线上的点
    // 2.2.遍历点，判断是否在originPath内
    // 2.3.如果有一个点在originPath内，则认为相交
    // 2.4.如果所有点都不在originPath内，则认为不相交
    List<Offset> points = [];
    PathMetrics targetPathMetrics = targetPath.computeMetrics();
    for (PathMetric pathMetric in targetPathMetrics) {
      // pathMetric为targetPath中的线段
      for (double i = 0; i < pathMetric.length; i++) {
        Tangent? tangent = pathMetric.getTangentForOffset(i); // 获取到线段上长度为i时的切线
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
