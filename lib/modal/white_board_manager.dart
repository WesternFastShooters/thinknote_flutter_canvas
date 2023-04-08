import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/type/configType/eraser_config.dart';
import 'package:flutter_application_2/type/configType/freedraw_config.dart';
import 'package:flutter_application_2/type/configType/transform_config.dart';
import 'package:flutter_application_2/type/elementType/stroke_type.dart';
import 'package:flutter_application_2/type/elementType/element_container.dart';
import 'package:get/get.dart';

enum ToolType {
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

enum ScaleLayerWidgetType {
  /// 中心缩小画布
  zoomOut,

  /// 中心放大画布
  zoomIn,
}

class WhiteBoardManager extends GetxController {
  /// 当前选用工具类型（默认为平移缩放）
  ToolType currentToolType = ToolType.transform;

  /// 存储正在绘制的canvas元素列表
  List<ElementContainer> drawingCanvasElementList = [];

  /// 存储已经绘制完成的canvas元素列表
  List<ElementContainer> canvasElementList = [];

  /// 指头编号
  int currentPointerId = -1;

  // 平移、缩放、位置相关配置
  TransformConfig transformConfig = TransformConfig();

  // 橡皮擦相关配置
  EraserConfig eraserConfig = EraserConfig(
    currentEraserPosition: null,
    eraserRadius: 10.0,
  );

  // 画笔相关配置
  FreedrawConfig freedrawConfig = FreedrawConfig();
}

extension FreeDrawLogic on WhiteBoardManager {
  onFreeDrawPointerDown(PointerDownEvent details) {
    freedrawConfig.simulatePressure = details.kind != PointerDeviceKind.stylus;
    if (drawingCanvasElementList.isEmpty && currentPointerId == -1) {
      drawingCanvasElementList.add(ElementContainer<Stroke>(
          type: ElementType.stroke, element: Stroke.init()));
      currentPointerId = details.pointer;
      update();
    }
  }

  onFreeDrawPointerMove(PointerMoveEvent details) {
    if (details.pointer == currentPointerId) {
      (drawingCanvasElementList[0] as ElementContainer<Stroke>)
          .element
          .storeStrokePoint(details);
      update();
    }
  }

  onFreeDrawPointerUp(PointerUpEvent details) {
    if (details.pointer == currentPointerId) {
      canvasElementList.add(
          (drawingCanvasElementList[0] as ElementContainer<Stroke>).copy());
      drawingCanvasElementList.clear();
      currentPointerId = -1;
      update();
    }
  }
}

extension EraserLogic on WhiteBoardManager {
  Future<void> onEraserPointerDown(PointerDownEvent details) async {
    if (drawingCanvasElementList.isEmpty && currentPointerId == -1) {
      eraserConfig.currentEraserPosition =
          transformToCanvasPoint(details.position);
      await erase();
      currentPointerId = details.pointer;
      update();
    }
  }

  Future<void> onEraserPointerMove(PointerMoveEvent details) async {
    if (details.pointer == currentPointerId) {
      eraserConfig.currentEraserPosition =
          transformToCanvasPoint(details.position);
      await erase();
      update();
    }
  }

  void onEraserPointerUp(PointerUpEvent details) {
    if (details.pointer == currentPointerId) {
      eraserConfig.currentEraserPosition = null;
      currentPointerId = -1;
      update();
    }
  }

  /// 擦除
  erase() async {
    if (eraserConfig.currentEraserPosition == null) return;
    final eraserPath = eraserConfig.eraserPath;

    canvasElementList.removeWhere((item) {
      return isEraserIntersecting(
          eraserPath: eraserPath, targetPath: (item.element as Stroke).path);
    });
    update();
  }
}

extension TransformLogic on WhiteBoardManager {
  /// 根据传入的坐标映射为canvas的坐标
  Offset transformToCanvasPoint(Offset position) =>
      ((position - transformConfig.curCanvasOffset) /
          transformConfig.curCanvasScale);

  /// 平移时移动执行回调
  onTranslatePointerMove(PointerMoveEvent event) {
    transformConfig.curCanvasOffset += event.localDelta;
    update();
  }

  /// 平移时抬起执行回调
  onTranslatePointerUp(PointerUpEvent event) {
    transformConfig.curCanvasOffset += event.localDelta;
    update();
  }

  /// 缩放开始执行回调
  onScaleStart(ScaleStartDetails detail) {
    _handleScaleEvent(detail);
  }

  /// 缩放中执行回调
  onScaleUpdate(ScaleUpdateDetails detail) {
    _handleScaleEvent(detail);
  }

  /// 缩放结束执行回调
  onScaleEnd(ScaleEndDetails details) {
    _handleScaleEvent(null);
  }

  void _handleScaleEvent(dynamic details) {
    if (details == null) {
      // transformConfig['lastScaleUpdateDetails'] = null;
      transformConfig.lastScaleUpdateDetails = null;
    } else {
      bool isScaleEvent = details.pointerCount >= 2;
      if (isScaleEvent) {
        transformConfig.curCanvasOffset = details.focalPointDelta;
        if (_executeScaling(details)) {
          update();
        }
      }
    }
  }

  bool _executeScaling(dynamic detail) {
    double scaleIncrement =
        detail.scale - transformConfig.lastScaleUpdateDetails?.scale ?? 0.0;

    // 判断是缩小还是放大
    ScaleLayerWidgetType type = scaleIncrement < 0
        ? ScaleLayerWidgetType.zoomOut
        : ScaleLayerWidgetType.zoomIn;

    double curScale = transformConfig.curCanvasScale;

    // 判断缩放后是否超过最大或最小值
    double newScale = type == ScaleLayerWidgetType.zoomOut
        ? max(curScale - scaleIncrement, transformConfig.minCanvasScale)
        : min(curScale + scaleIncrement, transformConfig.maxCanvasScale);

    if (newScale == curScale) {
      return false; // 缩放比例不变，无需执行更新操作
    }

    transformConfig.preCanvasScale = curScale;
    transformConfig.curCanvasScale = newScale;
    transformConfig.lastScaleUpdateDetails = detail;

    return true; // 执行了更新操作
  }
}

extension GestureLogic on WhiteBoardManager {
  /// 手势按下触发逻辑
  Future<void> onPointerDown(PointerDownEvent event) async {
    switch (currentToolType) {
      case ToolType.transform:
        break;
      case ToolType.freeDraw:
        onFreeDrawPointerDown(event);
        break;
      case ToolType.eraser:
        await onEraserPointerDown(event);
        break;
      case ToolType.lasso:
        break;
    }
  }

  /// 手势平移触发逻辑
  Future<void> onPointerMove(PointerMoveEvent event) async {
    switch (currentToolType) {
      case ToolType.transform:
        onTranslatePointerMove(event);
        break;
      case ToolType.freeDraw:
        onFreeDrawPointerMove(event);
        break;
      case ToolType.eraser:
        await onEraserPointerMove(event);
        break;
      case ToolType.lasso:
        break;
    }
  }

  /// 手势提起触发逻辑
  onPointerUp(PointerUpEvent event) {
    switch (currentToolType) {
      case ToolType.transform:
        // transformLogic.onPointerUp(event);
        onTranslatePointerUp(event);
        break;
      case ToolType.freeDraw:
        onFreeDrawPointerUp(event);
        break;
      case ToolType.eraser:
        onEraserPointerUp(event);
        break;
      case ToolType.lasso:
        break;
    }
  }
}

extension CommonUtils on WhiteBoardManager {
  /// 判断两个Path是否相交
  bool isEraserIntersecting(
      {required Path eraserPath, required Path? targetPath}) {
    if (targetPath == null) {
      return false;
    }
    // 1.判断如果targetPath的boundingBox在eraserPath的boundingBox之内，则一定相交
    Rect outerRect = eraserPath.getBounds();
    Rect innerRect = targetPath.getBounds();
    if (outerRect.contains(innerRect.topLeft) &&
        outerRect.contains(innerRect.bottomRight)) {
      return true;
    }
    // 2.如果eraserPath的boundingBox包裹了targetPath的boundingBox，则采取如下判断
    // 2.1.computeMetrics()方法获取targetPath曲线上的点
    // 2.2.遍历点，判断是否在eraserPath内
    // 2.3.如果有一个点在eraserPath内，则认为相交
    // 2.4.如果所有点都不在eraserPath内，则认为不相交
    List<Offset> points = [];
    ui.PathMetrics targetPathMetrics = targetPath.computeMetrics();
    for (ui.PathMetric pathMetric in targetPathMetrics) {
      for (double i = 0; i < pathMetric.length; i++) {
        ui.Tangent? tangent = pathMetric.getTangentForOffset(i);
        points.add(tangent!.position);
      }
    }
    for (Offset point in points) {
      if (eraserPath.contains(point)) {
        return true;
      }
    }

    return false;
  }
}
