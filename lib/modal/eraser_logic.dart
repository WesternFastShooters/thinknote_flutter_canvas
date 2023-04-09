import 'dart:ui' as ui;
import 'package:flutter/gestures.dart';
import 'package:flutter_application_2/modal/white_board_manager.dart';
import 'package:flutter_application_2/modal/transform_logic.dart';
import 'package:flutter_application_2/type/elementType/stroke_type.dart';

extension EraserLogic on WhiteBoardManager {
  onEraserPointerDown(PointerDownEvent details) {
    if (eraserConfig.currentEraserPosition == null && currentPointerId == -1) {
      eraserConfig.currentEraserPosition =
          transformToCanvasPoint(details.position);
      erase();
      currentPointerId = details.pointer;
      update();
    }
  }

  onEraserPointerMove(PointerMoveEvent details) {
    if (details.pointer == currentPointerId) {
      eraserConfig.currentEraserPosition =
          transformToCanvasPoint(details.position);
      erase();
      update();
    }
  }

  onEraserPointerUp(PointerUpEvent details) {
    if (details.pointer == currentPointerId) {
      eraserConfig.currentEraserPosition = null;
      currentPointerId = -1;
      update();
    }
  }

  /// 擦除
  erase() {
    if (eraserConfig.currentEraserPosition == null) return;
    final eraserPath = eraserConfig.eraserPath;

    canvasElementList.removeWhere((item) {
      return _isEraserIntersecting(
          eraserPath: eraserPath, targetPath: (item.element as Stroke).path);
    });
    update();
  }

  bool _isEraserIntersecting(
      {required ui.Path eraserPath, required ui.Path? targetPath}) {
    if (targetPath == null) {
      return false;
    }
    // 1.判断如果targetPath的boundingBox在eraserPath的boundingBox之内，则一定相交
    ui.Rect outerRect = eraserPath.getBounds();
    ui.Rect innerRect = targetPath.getBounds();
    if (outerRect.contains(innerRect.topLeft) &&
        outerRect.contains(innerRect.bottomRight)) {
      return true;
    }
    // 2.如果eraserPath的boundingBox包裹了targetPath的boundingBox，则采取如下判断
    // 2.1.computeMetrics()方法获取targetPath曲线上的点
    // 2.2.遍历点，判断是否在eraserPath内
    // 2.3.如果有一个点在eraserPath内，则认为相交
    // 2.4.如果所有点都不在eraserPath内，则认为不相交
    List<Offset> points = [];
    ui.PathMetrics targetPathMetrics = targetPath.computeMetrics();
    for (ui.PathMetric pathMetric in targetPathMetrics) {
      for (double i = 0; i < pathMetric.length; i++) {
        ui.Tangent? tangent = pathMetric.getTangentForOffset(i);
        points.add(tangent!.position);
      }
    }
    for (Offset point in points) {
      if (eraserPath.contains(point)) {
        return true;
      }
    }

    return false;
  }
}
