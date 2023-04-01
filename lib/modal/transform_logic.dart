import 'package:get/get.dart';
import 'package:flutter/material.dart';

enum ScaleLayerWidgetType {
  /// 中心缩小画布
  zoomOut,

  /// 中心放大画布
  zoomIn,
}

class TransformLogic extends GetxController {
  /// 用来计算双指缩放是缩小还是放大
  ScaleUpdateDetails? lastScaleUpdateDetails;

  /// 最小缩放
  final double minCanvasScale = 0.1;

  /// 最大缩放
  final double maxCanvasScale = 3.0;

  /// 画布上一次的缩放比例
  double preCanvasScale = 1.0;

  /// 画布当前的偏移量
  Rx<Offset> curCanvasOffset = Rx<Offset>(Offset.zero);

  /// 画布当前的缩放比例
  Rx<double> curCanvasScale = Rx<double>(1.0);

  /// 可视区域的大小
  Rx<Size> visibleAreaSize = Rx<Size>(Size.zero);

  /// 可视区域的中心
  Rx<Offset> visibleAreaCenter = Rx<Offset>(Offset.zero);

  /// 根据传入的坐标映射为canvas的坐标
  Offset transformToCanvasPoint(Offset position) =>
      ((position - curCanvasOffset.value) / curCanvasScale.value);

  /// 触发平移执行回调
  onPointerMove(PointerMoveEvent event) {
    curCanvasOffset.value += event.localDelta;
    update();
  }

  onPointerUp(PointerUpEvent event) {
    curCanvasOffset.value += event.localDelta;
    update();
  }

  /// 缩放开始执行回调
  onScaleStart(ScaleStartDetails detail) {
    if (detail.pointerCount >= 2) {
      lastScaleUpdateDetails = null;
      update();
    }
  }

  /// 缩放中执行回调
  onScaleUpdate(ScaleUpdateDetails detail) {
    if (detail.pointerCount >= 2) {
      _executeTranslating(detail);
      _executeScaling(detail);
      update();
    }
  }

  /// 缩放结束执行回调
  onScaleEnd(ScaleEndDetails details) {
    if (details.pointerCount >= 2) {
      lastScaleUpdateDetails = null;
      update();
    }
  }

  /// 执行平移
  void _executeTranslating(ScaleUpdateDetails details) {
    curCanvasOffset.value += details.focalPointDelta;
  }

  /// 执行缩放
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

  void aroundCenterScale({
    required Offset center,
    required ScaleLayerWidgetType type,
    double stepScale = 0.1,
  }) {
    if (type == ScaleLayerWidgetType.zoomOut) {
      // 中心缩小画布
      if (double.parse(curCanvasScale.toStringAsFixed(1)) <= minCanvasScale) {
        preCanvasScale = curCanvasScale.value;
        curCanvasScale.value = minCanvasScale;
      } else {
        preCanvasScale = curCanvasScale.value;
        curCanvasScale -= stepScale;
      }
    } else if (type == ScaleLayerWidgetType.zoomIn) {
      // 中心放大画布
      if (double.parse(curCanvasScale.toStringAsFixed(1)) >= maxCanvasScale) {
        preCanvasScale = curCanvasScale.value;
        curCanvasScale.value = maxCanvasScale;
      } else {
        preCanvasScale = curCanvasScale.value;
        curCanvasScale += stepScale;
      }
    }

    curCanvasOffset.value += getOffsetByScaleChange(
      center: center,
      curCanvasOffset: curCanvasOffset.value,
      curCanvasScale: curCanvasScale.value,
      preCanvasScale: preCanvasScale,
    );
    update();
  }

  Offset getOffsetByScaleChange({
    required Offset center,
    required Offset curCanvasOffset,
    required double curCanvasScale,
    required double preCanvasScale,
  }) {
    double thisTimeCanvasOffsetX = -(center.dx - curCanvasOffset.dx) *
        (curCanvasScale - preCanvasScale) /
        preCanvasScale;
    double thisTimeCanvasOffsetY = -(center.dy - curCanvasOffset.dy) *
        (curCanvasScale - preCanvasScale) /
        preCanvasScale;
    Offset thisTimeCanvasOffset =
        Offset(thisTimeCanvasOffsetX, thisTimeCanvasOffsetY);
    return thisTimeCanvasOffset;
  }
}
