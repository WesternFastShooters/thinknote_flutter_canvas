import 'dart:ui' as ui;
import 'package:flutter/gestures.dart';
import 'package:flutter_application_2/constants/default_pen_option.dart';
import 'package:flutter_application_2/model/algorithm/shape_recognition.dart';
import 'package:flutter_application_2/model/element/stroke.dart';
import 'package:flutter_application_2/model/store/canvas_store.dart';
import 'package:perfect_freehand/perfect_freehand.dart';

typedef StrokePoint = Point;

mixin Pen on CanvasStore {
  /// 当前画笔配置
  Map currentStrokeOption = defaultPenOption;

  /// 设置当前画笔配置
  setStrokeOption(Map option) {
    currentStrokeOption = option;
  }

  /// 笔画点集合
  List<StrokePoint> currentStrokePointList = [];

  /// 添加笔画坐标点到当前画笔坐标点集合中
  addStrokePoint(PointerEvent details) {
    var transformOffset = transformToCanvasOffset(details.localPosition);
    var strokePoint =
        StrokePoint(transformOffset.dx, transformOffset.dy, details.pressure);
    currentStrokePointList.add(strokePoint);
  }

  ui.Paint get currentStrokePaint =>
      ui.Paint()..color = currentStrokeOption['color'];
  ui.Path get currentStrokePath {
    var _path = ui.Path();
    final outlinePoints = getStroke(
      currentStrokePointList,
      size: currentStrokeOption['size'],
      thinning: currentStrokeOption['thinning'],
      smoothing: currentStrokeOption['smoothing'],
      streamline: currentStrokeOption['streamline'],
      taperStart: currentStrokeOption['taperStart'],
      capStart: currentStrokeOption['capStart'],
      taperEnd: currentStrokeOption['taperEnd'],
      capEnd: currentStrokeOption['capEnd'],
      simulatePressure: currentStrokeOption['simulatePressure'],
      isComplete: currentStrokeOption['isComplete'],
    );
    if (outlinePoints.isEmpty) {
      return _path;
    }
    if (outlinePoints.length < 2 && outlinePoints.isNotEmpty) {
      _path.addOval(ui.Rect.fromCircle(
          center: ui.Offset(outlinePoints[0].x, outlinePoints[0].y),
          radius: 1));
    } else {
      _path.moveTo(outlinePoints[0].x, outlinePoints[0].y);

      for (int i = 1; i < outlinePoints.length - 1; ++i) {
        final p0 = outlinePoints[i];
        final p1 = outlinePoints[i + 1];
        _path.quadraticBezierTo(
            p0.x, p0.y, (p0.x + p1.x) / 2, (p0.y + p1.y) / 2);
      }
    }

    return _path;
  }

  /// 重置自由绘画配置
  resetPen() {
    setStrokeOption(defaultPenOption);
    currentStrokePointList.clear();
  }
}

extension PenGesture on Pen {
  onPenDown(PointerDownEvent details) {
    if (currentStrokePointList.isEmpty) {
      // TODO: 设置笔画配置 调用setStrokeOption
      addStrokePoint(details);
    }
  }

  onPenMove(PointerMoveEvent details) {
    addStrokePoint(details);
  }

  onPenUp(PointerUpEvent details) {
    strokeList.add(Stroke(
      path: currentStrokePath,
      paint: currentStrokePaint,
    ));
    ShapeRecognition.recognize(currentStrokePath);
    resetPen();
  }
}
