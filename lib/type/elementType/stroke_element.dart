import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/type/elementType/whiteboard_element.dart';
import 'package:perfect_freehand/perfect_freehand.dart';

typedef StrokePoint = Point;

class Stroke extends WhiteBoardElement {
  Stroke();

  /// 元素类型
  @override
  ElementType elementType = ElementType.stroke;

  /// 拖拽偏移量
  @override
  Offset dragOffset = Offset.zero;

  /// 笔画配置属性
  Map option = Stroke.templateOption;

  /// 当前笔画点集合
  List<StrokePoint> currentStrokePointList = <StrokePoint>[];

  /// 绘制完成的笔画路径
  @override
  Path path = Path();

  /// 画迹样式
  Paint get paint => Paint()..color = option['color'];

  /// 当前笔画点路径
  Path get currentPath {
    var _path = Path();
    final outlinePoints = getStroke(
      currentStrokePointList,
      size: option['size'],
      thinning: option['thinning'],
      smoothing: option['smoothing'],
      streamline: option['streamline'],
      taperStart: option['taperStart'],
      capStart: option['capStart'],
      taperEnd: option['taperEnd'],
      capEnd: option['capEnd'],
      simulatePressure: option['simulatePressure'],
      isComplete: option['isComplete'],
    );
    if (outlinePoints.isEmpty) {
      return _path;
    }
    if (outlinePoints.length < 2 && outlinePoints.isNotEmpty) {
      _path.addOval(Rect.fromCircle(
          center: Offset(outlinePoints[0].x, outlinePoints[0].y), radius: 1));
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

  /// 判断笔画是否为空
  @override
  // bool get isEmpty => path.getBounds().isEmpty;
  bool get isEmpty =>
      currentStrokePointList.isEmpty && path.getBounds().isEmpty;

  /// path的中心位置
  Offset get center => path.getBounds().center;

  /// 模版笔画配置
  static const Map templateOption = {
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

  /// 设置笔画配置属性
  setOption(Map option) {
    this.option = {...this.option, ...option};
  }

  /// 画笔绘制完毕
  Stroke complete() {
    path = Path.from(currentPath);
    currentStrokePointList.clear();
    return this;
  }

  /// 移动画迹到目标位置
  @override
  translateElement({required Offset offset, required MoveElementMode mode}) {
    dragOffset += offset;
    final matrix4 = Matrix4.identity()..translate(dragOffset.dx, dragOffset.dy);
    path = path.transform(matrix4.storage);
  }

  /// 深拷贝
  @override
  WhiteBoardElement deepCopy() {
    return Stroke()
      ..option = Map.from(option)
      ..currentStrokePointList = List.from(currentStrokePointList)
      ..path = Path.from(path)
      ..dragOffset = dragOffset;
  }

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
    currentStrokePointList.add(point);
  }
}
