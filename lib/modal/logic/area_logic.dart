import 'package:flutter/material.dart';
import 'package:flutter_application_2/modal/board_modal.dart';
import 'package:flutter_application_2/constants/tool_type.dart';
import 'package:flutter_application_2/modal/utils/getOffsetByScaleChange.dart';

extension ScaleLogic on BoardModal {
  void onScaleStart(ScaleStartDetails details) {
    if (currentToolType != ToolType.translateAndScaleCanvas) {
      return;
    }
    if (details.pointerCount >= 2) {
      lastScaleUpdateDetails = null;
    }
  }

  void onScaleUpdate(ScaleUpdateDetails details) {
    if (currentToolType != ToolType.translateAndScaleCanvas) {
      return;
    }
    if (details.pointerCount >= 2) {
      _executeTranslating(details);
      _executeScaling(details);
    }
  }

  void onScaleEnd(ScaleEndDetails details) {
    if (currentToolType != ToolType.translateAndScaleCanvas) {
      return;
    }
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
    curCanvasOffset += getOffsetByScaleChange(
      center: visibleAreaCenter,
      curCanvasOffset: curCanvasOffset,
      curCanvasScale: curCanvasScale,
      preCanvasScale: preCanvasScale,
    );

    // updatePresentationLayerWidget();
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

    curCanvasOffset += getOffsetByScaleChange(
      center: center,
      curCanvasOffset: curCanvasOffset,
      curCanvasScale: curCanvasScale,
      preCanvasScale: preCanvasScale,
    );

    update();
  }
}

extension TranslateLogic on BoardModal {
  void execPointerMoveForTranslate(PointerMoveEvent event) {
    if (currentToolType != ToolType.translateAndScaleCanvas) {
      return;
    }
    curCanvasOffset += event.localDelta;
    update();
  }

  void execPointerUpForTranslate(PointerUpEvent event) {
    if (currentToolType != ToolType.translateAndScaleCanvas) {
      return;
    }
    curCanvasOffset += event.localDelta;
    update();
  }
}
