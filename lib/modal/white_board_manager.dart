import 'package:flutter_application_2/type/configType/eraser_config.dart';
import 'package:flutter_application_2/type/configType/freedraw_config.dart';
import 'package:flutter_application_2/type/configType/lasso_config.dart';
import 'package:flutter_application_2/type/configType/transform_config.dart';
import 'package:flutter_application_2/type/elementType/element_container.dart';
import 'package:get/get.dart';

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

enum ScaleLayerWidgetType {
  /// 中心缩小画布
  zoomOut,

  /// 中心放大画布
  zoomIn,
}

class WhiteBoardManager extends GetxController {
  /// 当前选用工具类型（默认为平移缩放）
  ActionType currentToolType = ActionType.transform;

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

  /// 套索相关配置
  LassoConfig lassoConfig = LassoConfig();
}
