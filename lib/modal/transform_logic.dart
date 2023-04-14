import 'package:flutter/material.dart';
import 'package:flutter_application_2/modal/common_utils.dart';
import 'package:flutter_application_2/modal/white_board_manager.dart';

extension TransformLogic on WhiteBoardManager {
  /// 平移时移动执行回调
  onTranslatePointerMove(PointerMoveEvent event) {
    transformConfig.globalCanvasOffset += event.localDelta;
    update();
  }

  /// 平移时抬起执行回调
  onTranslatePointerUp(PointerUpEvent event) {
    transformConfig.globalCanvasOffset += event.localDelta;
    update();
  }

  /// 缩放开始执行回调
  onScaleStart(ScaleStartDetails detail) {
    if (currentToolType != ActionType.transform) return;
    if (detail.pointerCount >= 2) {
      transformConfig.lastScaleUpdateDetails = null;
      update();
    }
  }

  /// 缩放中执行回调
  onScaleUpdate(ScaleUpdateDetails detail) {
    if (currentToolType != ActionType.transform) return;
    if (detail.pointerCount >= 2) {
      _executeTranslating(detail);
      _executeScaling(detail);
      update();
    }
  }

  /// 缩放结束执行回调
  onScaleEnd(ScaleEndDetails details) {
    if (currentToolType != ActionType.transform) return;
    if (details.pointerCount >= 2) {
      transformConfig.lastScaleUpdateDetails = null;
      update();
    }
  }

  // 执行缩放
  void _executeScaling(ScaleUpdateDetails details) {
    if (transformConfig.lastScaleUpdateDetails == null) {
      transformConfig.lastScaleUpdateDetails = details;
      return;
    }

    double scaleIncrement =
        details.scale - transformConfig.lastScaleUpdateDetails!.scale;
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
    transformConfig.lastScaleUpdateDetails = details;
  }

  // 执行平移
  void _executeTranslating(ScaleUpdateDetails details) {
    transformConfig.globalCanvasOffset += details.focalPointDelta;
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
    scaleTween.begin = transformConfig.globalCanvasScale;
    scaleTween.end = targetScale;
    animationController.reset();
    animationController.forward();
  }

  void updateLayerWidgetScale({
    required double scale,
  }) {
    transformConfig.globalPreCanvasScale = transformConfig.globalCanvasScale;
    transformConfig.globalCanvasScale = scale;
    transformConfig.globalCanvasOffset +=
        transformToCanvasPoint(transformConfig.visibleAreaCenter);

    update();
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
      if (double.parse(transformConfig.globalCanvasScale.toStringAsFixed(1)) <=
          transformConfig.globalMinCanvasScale) {
        transformConfig.globalPreCanvasScale =
            transformConfig.globalCanvasScale;
        transformConfig.globalCanvasScale =
            transformConfig.globalMinCanvasScale;
      } else {
        transformConfig.globalPreCanvasScale =
            transformConfig.globalCanvasScale;
        transformConfig.globalCanvasScale -= stepScale;
      }
    } else if (type == ScaleLayerWidgetType.zoomIn) {
      // 中心放大画布
      if (double.parse(transformConfig.globalCanvasScale.toStringAsFixed(1)) >=
          transformConfig.globalMaxCanvasScale) {
        transformConfig.globalPreCanvasScale =
            transformConfig.globalCanvasScale;
        transformConfig.globalCanvasScale =
            transformConfig.globalMaxCanvasScale;
      } else {
        transformConfig.globalPreCanvasScale =
            transformConfig.globalCanvasScale;
        transformConfig.globalCanvasScale += stepScale;
      }
    }

    transformConfig.globalCanvasOffset += transformToCanvasPoint(center);
    update();
  }
}
