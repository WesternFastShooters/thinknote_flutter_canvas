import 'package:flutter_application_2/constants/tool_type.dart';
import 'package:flutter_application_2/modal/type/base_element_model.dart';
import 'package:flutter_application_2/modal/type/pencil_element_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class BoardModal extends GetxController {
  /// 当前选用工具类型
  ToolType currentToolType = ToolType.translateAndScaleCanvas;

  /// 画布当前的偏移量
  Offset curCanvasOffset = Offset.zero;

  /// 可视区域的大小
  Size visibleAreaSize = Size.zero;

  /// 可视区域的中心
  Offset visibleAreaCenter = Offset.zero;

  /// 用来计算双指缩放是缩小还是放大
  ScaleUpdateDetails? lastScaleUpdateDetails;

  /// 画布当前的缩放比例
  double curCanvasScale = 1.0;

  /// 画布上一次的缩放比例
  double preCanvasScale = 1.0;

  /// 最小缩放
  final double minCanvasScale = 0.1;

  /// 最大缩放
  final double maxCanvasScale = 3.0;

  /// 正在绘制的元素
  List<BaseElementModel> drawingElementModelList = [];

  /// 当前笔画的配置属性
  StrokeOptions currentStrokeOptions = StrokeOptions();

  /// 所有笔画
  List<PencilElementModel> pencilElementModelList = [];
  
}
