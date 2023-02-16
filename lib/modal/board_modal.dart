import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../constants/canvas_id.dart';
import '../utils/algorithm_util.dart';

enum ScaleLayerWidgetType {
  /// 中心缩小画布
  zoomOut,

  /// 中心放大画布
  zoomIn,
}

class BoardModal extends GetxController {
  // 画布当前的偏移量
  Offset curCanvasOffset = Offset.zero;

  // 可视区域的大小
  Size visibleAreaSize = Size.zero;

  // 可视区域的中心
  Offset visibleAreaCenter = Offset.zero;

  // 上一次缩放数据（GestureDetector专用的）
  // 用来计算双指缩放是缩小还是放大
  ScaleUpdateDetails? lastScaleUpdateDetails;

  // 画布当前的缩放比例
  double curCanvasScale = 1.0;

  // 画布上一次的缩放比例
  double preCanvasScale = 1.0;

  // 最小缩放
  final double minCanvasScale = 0.1;

  // 最大缩放
  final double maxCanvasScale = 3.0;
}

extension GestureDetectorLogic on BoardModal {
  void onPointerMove(PointerMoveEvent event) {
    Offset point = AlgorithmUtil.transformScreenPointToCanvasPoint(
      screenPoint: event.localPosition,
      curCanvasOffset: curCanvasOffset,
      curCanvasScale: curCanvasScale,
    );
    curCanvasOffset += event.localDelta;
    update([CanvasID.backgroundLayerWidgetId, CanvasID.rectLayerWidgetID]);
  }

  void onPointerUp(PointerUpEvent event) {
    Offset point = AlgorithmUtil.transformScreenPointToCanvasPoint(
      screenPoint: event.localPosition,
      curCanvasOffset: curCanvasOffset,
      curCanvasScale: curCanvasScale,
    );
    curCanvasOffset += event.localDelta;
    update([CanvasID.backgroundLayerWidgetId, CanvasID.rectLayerWidgetID]);
  }
}

extension ScaleLayerWidgetLogic on BoardModal {
  void onScaleStart(ScaleStartDetails details) {
    if (details.pointerCount >= 2) {
      lastScaleUpdateDetails = null;
    }
  }

  void onScaleUpdate(ScaleUpdateDetails details) {
    if (details.pointerCount >= 2) {
      _executeTranslating(details);
      _executeScaling(details);
    }
  }

  void onScaleEnd(ScaleEndDetails details) {
    if (details.pointerCount >= 2) {
      lastScaleUpdateDetails = null;
    }
  }

  // 执行缩放
  void _executeScaling(ScaleUpdateDetails details) {
    if (lastScaleUpdateDetails == null) {
      lastScaleUpdateDetails = details;
      return;
    }

    double scaleIncrement = details.scale - lastScaleUpdateDetails!.scale;
    if (scaleIncrement < 0) {
      // 缩小
      aroundCenterScale(
        type: ScaleLayerWidgetType.zoomOut,
        center: details.localFocalPoint,
        stepScale: -scaleIncrement,
      );
    }
    if (scaleIncrement > 0) {
      // 放大
      aroundCenterScale(
        type: ScaleLayerWidgetType.zoomIn,
        center: details.localFocalPoint,
        stepScale: scaleIncrement,
      );
    }

    // 缩放过程中实时更新上一次缩放的数据
    lastScaleUpdateDetails = details;
  }

  // 执行平移
  void _executeTranslating(ScaleUpdateDetails details) {
    curCanvasOffset += details.focalPointDelta;
  }

  /// 以屏幕中心为缩放中心，通过动画的方式把画布缩放到[targetScale]
  ///
  /// 手动点击放大、缩小按钮
  /// 100%
  void aroundScreenScaleTo({
    required targetScale,
    required AnimationController animationController,
    required Tween<double> scaleTween,
  }) {
    scaleTween.begin = curCanvasScale;
    scaleTween.end = targetScale;
    animationController.reset();
    animationController.forward();
  }

  void updateLayerWidgetScale({
    required double scale,
  }) {
    preCanvasScale = curCanvasScale;
    curCanvasScale = scale;
    curCanvasOffset += AlgorithmUtil.centerZoomAlgorithm(
      center: visibleAreaCenter,
      curCanvasOffset: curCanvasOffset,
      curCanvasScale: curCanvasScale,
      preCanvasScale: preCanvasScale,
    );

    // updatePresentationLayerWidget();
    update([CanvasID.backgroundLayerWidgetId, CanvasID.rectLayerWidgetID]);
  }

  /// 以任意点为中心缩放画布
  ///
  /// 多指缩放
  /// 鼠标滚轮缩放
  void aroundCenterScale({
    required Offset center,
    required ScaleLayerWidgetType type,
    double stepScale = 0.1,
  }) {
    if (type == ScaleLayerWidgetType.zoomOut) {
      // 中心缩小画布
      if (double.parse(curCanvasScale.toStringAsFixed(1)) <= minCanvasScale) {
        preCanvasScale = curCanvasScale;
        curCanvasScale = minCanvasScale;
      } else {
        preCanvasScale = curCanvasScale;
        curCanvasScale -= stepScale;
      }
    } else if (type == ScaleLayerWidgetType.zoomIn) {
      // 中心放大画布
      if (double.parse(curCanvasScale.toStringAsFixed(1)) >= maxCanvasScale) {
        preCanvasScale = curCanvasScale;
        curCanvasScale = maxCanvasScale;
      } else {
        preCanvasScale = curCanvasScale;
        curCanvasScale += stepScale;
      }
    }

    curCanvasOffset += AlgorithmUtil.centerZoomAlgorithm(
      center: center,
      curCanvasOffset: curCanvasOffset,
      curCanvasScale: curCanvasScale,
      preCanvasScale: preCanvasScale,
    );

    update([CanvasID.backgroundLayerWidgetId, CanvasID.rectLayerWidgetID]);
  }
}
