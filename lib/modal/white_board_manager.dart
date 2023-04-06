import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/type/stroke.dart';
import 'package:flutter_application_2/type/white_board_element.dart';
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
  List<WhiteBoardElement> drawingCanvasElementList = [];

  /// 存储已经绘制完成的canvas元素列表
  List<WhiteBoardElement> canvasElementList = [];

  /// 指头编号
  int currentPointerId = -1;

  // 平移、缩放、位置相关配置
  Map transformConfig = {
    'minCanvasScale': 0.1, // 最小缩放
    'maxCanvasScale': 3.0, // 最大缩放
    'preCanvasScale': 1.0, // 画布上一次的缩放比例
    'curCanvasOffset': Offset.zero, // 画布当前的偏移量
    'curCanvasScale': 1.0, // 画布当前的缩放比例
    'visibleAreaSize': Size.zero, // 可视区域的大小
    'visibleAreaCenter': Offset.zero, // 可视区域的中心
    'lastScaleUpdateDetails': null, // 用来计算双指缩放是缩小还是放大
  };

  // 橡皮擦相关配置
  Map eraserConfig = {
    'currentEraserPosition': null, // 当前橡皮擦的位置
    'eraserRadius': 10.0, // 橡皮擦半径
  };

  // 画笔相关配置
  Map freedrawConfig = {
    'currentStrokeOption': {
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
      'color': Colors.green,
    },
  };
}

extension FreeDrawLogic on WhiteBoardManager {
  onFreeDrawPointerDown(PointerDownEvent details) {
    freedrawConfig['currentStrokeOption'] = {
      ...freedrawConfig['currentStrokeOption'],
      'simulatePressure': details.kind != PointerDeviceKind.stylus,
    };
    // drawingCanvasElementList为空，说明当前没有正在绘制的元素，则新建一个stroke加入drawingCanvasElementList中
    // drawingCanvasElementList不为空，说明当前有正在绘制的元素，则检查pointerId是否为-1，如果是-1则drawingCanvasElementList第一个元素需要更新
    // 如果不是-1，则return
    if (drawingCanvasElementList.isEmpty && currentPointerId == -1) {
      drawingCanvasElementList.add(WhiteBoardElement<Stroke>(
          type: WhiteBoardElementType.stroke, element: Stroke.init()));
      currentPointerId = details.pointer;
      update();
    }
  }

  onFreeDrawPointerMove(PointerMoveEvent details) {
    if (details.pointer == currentPointerId) {
      (drawingCanvasElementList[0] as WhiteBoardElement<Stroke>)
          .element
          .storeStrokePoint(details);
      update();
    }
  }

  onFreeDrawPointerUp(PointerUpEvent details) {
    if (details.pointer == currentPointerId) {
      canvasElementList.add(
          (drawingCanvasElementList[0] as WhiteBoardElement<Stroke>).copy());
      drawingCanvasElementList.clear();
      currentPointerId = -1;
      update();
    }
  }
}

extension EraserLogic on WhiteBoardManager {
  void onEraserPointerDown(PointerDownEvent details) {
    if (drawingCanvasElementList.isEmpty && currentPointerId == -1) {
      eraserConfig['currentEraserPosition'] =
          transformToCanvasPoint(details.position);
      erase();
      currentPointerId = details.pointer;
      update();
    }
  }

  void onEraserPointerMove(PointerMoveEvent details) {
    if (details.pointer == currentPointerId) {
      eraserConfig['currentEraserPosition'] =
          transformToCanvasPoint(details.position);
      erase();
      update();
    }
  }

  void onEraserPointerUp(PointerUpEvent details) {
    if (details.pointer == currentPointerId) {
      eraserConfig['currentEraserPosition'] = null;
      currentPointerId = -1;
      update();
    }
  }

  /// 擦除
  erase() {
    if (eraserConfig['currentEraserPosition'] == null) return;
    // 1.根据eraserConfig['currentEraserPosition']和eraserConfig['eraserRadius']构造一个path
    // 2.将该path逐个与canvasElementList中的WhiteBoardElement.element.path进行相交判断
    // 3.如果相交，则将该WhiteBoardElement从canvasElementList中移除
    // 4.如果不相交，则不做任何操作
    // 5.最后调用update()刷新页面

    final eraserPath = Path()
      ..addOval(Rect.fromCircle(
          center: eraserConfig['currentEraserPosition']!,
          radius: eraserConfig['eraserRadius']));
    canvasElementList.removeWhere((element) {
      return element.element.path.intersects(eraserPath);
    });
    update();
  }
}

extension TransformLogic on WhiteBoardManager {
  /// 根据传入的坐标映射为canvas的坐标
  Offset transformToCanvasPoint(Offset position) =>
      ((position - transformConfig['curCanvasOffset']) /
          transformConfig['curCanvasScale']);

  /// 平移时移动执行回调
  onTranslatePointerMove(PointerMoveEvent event) {
    transformConfig['curCanvasOffset'] += event.localDelta;
    update();
  }

  /// 平移时抬起执行回调
  onTranslatePointerUp(PointerUpEvent event) {
    transformConfig['curCanvasOffset'] += event.localDelta;
    update();
  }

  /// 缩放开始执行回调
  onScaleStart(detail) {
    _handleScaleEvent(detail);
  }

  /// 缩放中执行回调
  onScaleUpdate(detail) {
    _handleScaleEvent(detail);
  }

  /// 缩放结束执行回调
  onScaleEnd(ScaleEndDetails details) {
    _handleScaleEvent(null);
  }

  void _handleScaleEvent(ScaleUpdateDetails? details) {
    if (details == null) {
      transformConfig['lastScaleUpdateDetails'] = null;
    } else {
      bool isScaleEvent = details.pointerCount >= 2;
      if (isScaleEvent) {
        // _executeTranslating(details);
        transformConfig['curCanvasOffset'] = details.focalPointDelta;
        if (_executeScaling(details)) {
          update();
        }
      }
    }
  }

  bool _executeScaling(ScaleUpdateDetails detail) {
    double scaleIncrement =
        detail.scale - transformConfig['lastScaleUpdateDetails']?.scale ?? 0.0;

    // 判断是缩小还是放大
    ScaleLayerWidgetType type = scaleIncrement < 0
        ? ScaleLayerWidgetType.zoomOut
        : ScaleLayerWidgetType.zoomIn;

    double curScale = transformConfig['curCanvasScale'];

    // 判断缩放后是否超过最大或最小值
    double newScale = type == ScaleLayerWidgetType.zoomOut
        // ? max(curScale - scaleIncrement, minCanvasScale)
        ? max(curScale - scaleIncrement, transformConfig['minCanvasScale'])
        : min(curScale + scaleIncrement, transformConfig['maxCanvasScale']);

    if (newScale == curScale) {
      return false; // 缩放比例不变，无需执行更新操作
    }

    transformConfig['preCanvasScale'] = curScale;
    transformConfig['curCanvasScale'] = newScale;

    transformConfig['lastScaleUpdateDetails'] = detail;

    return true; // 执行了更新操作
  }
}
