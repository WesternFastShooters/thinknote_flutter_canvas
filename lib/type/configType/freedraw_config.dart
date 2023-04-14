import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/type/elementType/stroke_type.dart';

class FreedrawConfig {
  /// 模版笔画配置
  static const Map _templateOption = {
    'size': 3.0,
    'thinning': 0.1,
    'smoothing': 0.5,
    'streamline': 0.5,
    'taperStart': 0.0,
    'capStart': true,
    'taperEnd': 0.1,
    'capEnd': true,
    'simulatePressure': true,
    'isComplete': false,
    'color': Color.fromARGB(255, 192, 80, 117),
  };

  /// 当前笔画配置
  Map currentOption = _templateOption;

  /// 设置当前笔画配置
  setCurrentOption(Map option) {
    currentOption = {
      ...currentOption,
      ...option,
    };
  }

  /// 当前笔画
  Stroke currentStroke =
      Stroke(option: _templateOption, strokePoints: <StrokePoint>[]);

  /// 为当前笔画添加画迹点
  addStrokePoint({required Offset position, required PointerEvent pointInfo}) {
    final StrokePoint point = pointInfo.kind == PointerDeviceKind.stylus
        ? StrokePoint(
            position.dx,
            position.dy,
            (pointInfo.pressure - pointInfo.pressureMin) /
                (pointInfo.pressureMax - pointInfo.pressureMin),
          )
        : StrokePoint(position.dx, position.dy);
    currentStroke.strokePoints.add(point);
  }

  /// 配置重置
  reset() {
    currentOption = _templateOption;
    currentStroke =
        Stroke(option: _templateOption, strokePoints: <StrokePoint>[]);
  }
}
