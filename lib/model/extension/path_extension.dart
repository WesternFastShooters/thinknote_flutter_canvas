import 'dart:ui' as ui;

extension PathExtension on ui.Path {
  List<ui.Offset> toBePoints() {
    List<ui.Offset> points = [];
    ui.PathMetrics targetPathMetrics = computeMetrics();
    for (ui.PathMetric pathMetric in targetPathMetrics) {
      // pathMetric为targetPath中的线段
      for (double i = 0; i < pathMetric.length; i++) {
        ui.Tangent? tangent =
            pathMetric.getTangentForOffset(i); // 获取到线段上长度为i时的切线
        points.add(tangent!.position); // 获取到切线对应的位置
      }
    }
    return points;
  }
}

