import 'package:flutter/animation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_application_2/modal/utils/geometry_tool.dart';
import '../white_board_manager.dart';

enum ScaleLayerWidgetType {
  /// 中心缩小画布
  zoomOut,

  /// 中心放大画布
  zoomIn,
}

extension TransformFuction on WhiteBoardManager {
  // 执行缩放
  void executeScaling(ScaleUpdateDetails details) {
    if (whiteBoardConfig.lastScaleUpdateDetails == null) {
      whiteBoardConfig.lastScaleUpdateDetails = details;
      return;
    }

    double scaleIncrement =
        details.scale - whiteBoardConfig.lastScaleUpdateDetails!.scale;
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
    whiteBoardConfig.lastScaleUpdateDetails = details;
  }

  // 执行平移
  void executeTranslating(ScaleUpdateDetails details) {
    whiteBoardConfig.globalCanvasOffset += details.focalPointDelta;
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
    scaleTween.begin = whiteBoardConfig.globalCanvasScale;
    scaleTween.end = targetScale;
    animationController.reset();
    animationController.forward();
  }

  void updateLayerWidgetScale({
    required double scale,
  }) {
    whiteBoardConfig.globalPreCanvasScale = whiteBoardConfig.globalCanvasScale;
    whiteBoardConfig.globalCanvasScale = scale;
    whiteBoardConfig.globalCanvasOffset += transformToCanvasPoint(
      whiteBoardConfig.visibleAreaCenter,
    );
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
      if (double.parse(whiteBoardConfig.globalCanvasScale.toStringAsFixed(1)) <=
          whiteBoardConfig.globalMinCanvasScale) {
        whiteBoardConfig.globalPreCanvasScale =
            whiteBoardConfig.globalCanvasScale;
        whiteBoardConfig.globalCanvasScale =
            whiteBoardConfig.globalMinCanvasScale;
      } else {
        whiteBoardConfig.globalPreCanvasScale =
            whiteBoardConfig.globalCanvasScale;
        whiteBoardConfig.globalCanvasScale -= stepScale;
      }
    } else if (type == ScaleLayerWidgetType.zoomIn) {
      // 中心放大画布
      if (double.parse(whiteBoardConfig.globalCanvasScale.toStringAsFixed(1)) >=
          whiteBoardConfig.globalMaxCanvasScale) {
        whiteBoardConfig.globalPreCanvasScale =
            whiteBoardConfig.globalCanvasScale;
        whiteBoardConfig.globalCanvasScale =
            whiteBoardConfig.globalMaxCanvasScale;
      } else {
        whiteBoardConfig.globalPreCanvasScale =
            whiteBoardConfig.globalCanvasScale;
        whiteBoardConfig.globalCanvasScale += stepScale;
      }
    }

    whiteBoardConfig.globalCanvasOffset += transformToCanvasPoint(
      center,
    );
  }
}
