import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter_application_2/model/eraser/eraser_gesture.dart';
import 'package:flutter_application_2/model/eraser/eraser_model.dart';
import 'package:flutter_application_2/model/freedraw/freedraw_gesture.dart';
import 'package:flutter_application_2/model/freedraw/freedraw_model.dart';
import 'package:flutter_application_2/model/lasso/lasso_gesture.dart';
import 'package:flutter_application_2/model/lasso/lasso_model.dart';
import 'package:flutter_application_2/model/menu/menu_gesture.dart';
import 'package:flutter_application_2/model/menu/menu_model.dart';
import 'package:flutter_application_2/model/transform/transform_gesture.dart';
import 'package:flutter_application_2/model/transform/transform_model.dart';
import 'package:get/get.dart';

import '../type/elementType/whiteboard_element.dart';

enum ActionType {
  /// 自由绘画模式
  freeDraw,

  /// 平移或缩放画布模式
  transform,

  /// 橡皮擦模式
  eraser,

  /// 套索模式
  lasso,

  /// 拖拽模式
  drag,
}

class WhiteBoardManager extends GetxController {
  WhiteBoardModel whiteBoardModel = WhiteBoardModel();

  /// 切换当前工具
  setCurrentToolType(ActionType type) {
    whiteBoardModel.currentToolType = type;
    onSwitchCurrentToolType();
    update();
  }

  /// 切换当前工具触发逻辑
  onSwitchCurrentToolType() {
    whiteBoardModel.resetEraserConfig();
    whiteBoardModel.resetFreeDraw();
    whiteBoardModel.resetLassoConfig();
  }

  clickMenuItem(MenuItemEnum item) {
    whiteBoardModel.clickMenuItem(item);
    update();
  }

  /// 手势按下触发逻辑
  onPointerDown(PointerDownEvent event) {
    switch (whiteBoardModel.currentToolType) {
      case ActionType.freeDraw:
        onFreeDrawPointerDown(event);
        break;
      case ActionType.eraser:
        onEraserPointerDown(event);
        break;
      case ActionType.lasso:
        onLassoPointerDown(event);
        onMenuPointerDown(event);
        break;
    }
    update();
  }

  /// 手势平移触发逻辑
  onPointerMove(PointerMoveEvent event) {
    switch (whiteBoardModel.currentToolType) {
      case ActionType.transform:
        onTransformPointerMove(event);
        break;
      case ActionType.freeDraw:
        onFreeDrawPointerMove(event);
        break;
      case ActionType.eraser:
        onEraserPointerMove(event);
        break;
      case ActionType.lasso:
        onLassoPointerMove(event);
        break;
    }
    update();
  }

  /// 手势提起触发逻辑
  onPointerUp(PointerUpEvent event) {
    switch (whiteBoardModel.currentToolType) {
      case ActionType.freeDraw:
        onFreeDrawPointerUp(event);
        break;
      case ActionType.eraser:
        onEraserPointerUp(event);
        break;
      case ActionType.lasso:
        onLassoPointerUp(event);
        break;
    }
    update();
  }

  /// 缩放开始触发逻辑
  onScaleStart(ScaleStartDetails details) {
    switch (whiteBoardModel.currentToolType) {
      case ActionType.transform:
        onTransformScaleStart(details);
        break;
    }
    update();
  }

  /// 缩放中触发逻辑
  onScaleUpdate(ScaleUpdateDetails details) {
    switch (whiteBoardModel.currentToolType) {
      case ActionType.transform:
        onTransformScaleUpdate(details);
        break;
    }
    update();
  }

  /// 缩放结束触发逻辑
  onScaleEnd(ScaleEndDetails details) {
    switch (whiteBoardModel.currentToolType) {
      case ActionType.transform:
        onTransformScaleEnd(details);
        break;
    }
    update();
  }

  /// 双击触发逻辑
  onDoubleTapDown(TapDownDetails details) {
    switch (whiteBoardModel.currentToolType) {
      case ActionType.lasso:
        onMenuDoubleTapDown(details);
        break;
    }
    update();
  }
}

class WhiteBoardModel
    with
        WhiteBoardGeometry,
        WhiteBoardInfo,
        TransformModel,
        EraserModel,
        FreedrawModel,
        LassoModel,
        MenuModel {}

mixin WhiteBoardGeometry {
  // 画布的偏移量
  Offset globalCanvasOffset = Offset.zero;

  // 画布当前的缩放比例
  double globalCanvasScale = 1.0;

  /// 根据传入的坐标映射为canvas的坐标
  Offset transformToCanvasPoint(
    currentPosition,
  ) =>
      ((currentPosition - globalCanvasOffset) / globalCanvasScale);

  /// 判断两个Path是否相交
  bool isIntersecting({required Path originPath, required Path? targetPath}) {
    if (targetPath == null || originPath.getBounds().isEmpty) {
      return false;
    }

    // 1.判断如果targetPath的boundingBox和originPath的boundingBox不重合，则一定不相交
    Rect outerRect = originPath.getBounds();
    Rect innerRect = targetPath.getBounds();
    if (!outerRect.overlaps(innerRect)) {
      return false;
    }

    // 2.如果originPath的boundingBox包裹了targetPath的boundingBox，则采取如下判断
    // 2.1.computeMetrics()方法获取targetPath曲线上的点
    // 2.2.遍历点，判断是否在originPath内
    // 2.3.如果有一个点在originPath内，则认为相交
    // 2.4.如果所有点都不在originPath内，则认为不相交
    List<Offset> points = [];
    PathMetrics targetPathMetrics = targetPath.computeMetrics();
    for (PathMetric pathMetric in targetPathMetrics) {
      // pathMetric为targetPath中的线段
      for (double i = 0; i < pathMetric.length; i++) {
        Tangent? tangent = pathMetric.getTangentForOffset(i); // 获取到线段上长度为i时的切线
        points.add(tangent!.position); // 获取到切线对应的位置
      }
    }
    for (Offset point in points) {
      if (originPath.contains(point)) {
        return true;
      }
    }

    return false;
  }
}

mixin WhiteBoardInfo {
  /// 当前选用工具类型（默认为平移缩放）
  ActionType currentToolType = ActionType.transform;

  /// 存储已经绘制完成的canvas元素列表
  List<WhiteBoardElement> canvasElementList = [];

}
