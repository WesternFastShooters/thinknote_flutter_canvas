import 'package:flutter/gestures.dart';
import 'package:flutter_application_2/model/store/canvas_store.dart';

mixin Hand on CanvasStore {
  /// 最小缩放
  double minCanvasScale = 1.0;

  // 最大缩放
  double maxCanvasScale = 3.0;

  /// 画布上一次的缩放比例
  double? preCanvasScale;

  translate(Offset offset) {
    canvasOffset += offset;
  }

  scale(double scale) {
    if (preCanvasScale == null) {
      preCanvasScale = scale;
      return;
    }
    double scaleIncrement = scale - preCanvasScale!;
    aroundCenterScale(scaleIncrement);
    preCanvasScale = scale;
  }

  aroundCenterScale(scaleIncrement) {
    var stepScale = scaleIncrement.abs();
    if (scaleIncrement < 0) {
      // 中心缩小画布
      if (double.parse(canvasScale.toStringAsFixed(1)) <= minCanvasScale) {
        canvasScale = minCanvasScale;
      } else {
        canvasScale -= stepScale;
      }
    } else if (scaleIncrement < 0) {
      // 中心放大画布
      if (double.parse(canvasScale.toStringAsFixed(1)) >= maxCanvasScale) {
        canvasScale = maxCanvasScale;
      } else {
        canvasScale += stepScale;
      }
    }
  }
}

extension HandGesture on Hand {
  onHandMove(PointerMoveEvent event) {
    translate(event.localDelta);
  }

  onHandScaleStart(ScaleStartDetails detail) {
    if (detail.pointerCount >= 2) {
      preCanvasScale = null;
    }
  }

  onHandScaleUpdate(ScaleUpdateDetails detail) {
    if (detail.pointerCount >= 2) {
      translate(detail.focalPointDelta);
      scale(detail.scale);
    }
  }

  onHandScaleEnd(ScaleEndDetails details) {
    if (details.pointerCount >= 2) {
      preCanvasScale = null;
    }
  }
}
