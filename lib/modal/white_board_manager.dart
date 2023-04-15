import 'package:flutter_application_2/modal/common_utils.dart';
import 'package:flutter_application_2/type/configType/eraser_config.dart';
import 'package:flutter_application_2/type/configType/freedraw_config.dart';
import 'package:flutter_application_2/type/configType/lasso_config.dart';
import 'package:flutter_application_2/type/configType/menu_config.dart';
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
  @override
  void onInit() {
    ever(currentToolType, (_) {
      resetConfig();
    });
    super.onInit();
  }

  /// 当前选用工具类型（默认为平移缩放）
  Rx<ActionType> currentToolType = Rx(ActionType.transform);
  setCurrentToolType(ActionType type) {
    currentToolType.value = type;
  }

  /// 重置配置
  resetConfig() {
    freedrawConfig.reset();
    eraserConfig.reset();
    lassoConfig.reset();
    update();
  }

  /// 存储已经绘制完成的canvas元素列表
  List<ElementContainer> canvasElementList = [];

  /// 存储被套索选中的元素
  List<ElementContainer> selectedElementList = [];

  /// 过滤出被套索选中的元素
  setSelectedElement() {
    selectedElementList = canvasElementList
        .where((element) => isIntersecting(
            originPath: lassoConfig.closedShapePath!,
            targetPath: (element.element).path))
        .toList();
  }

  /// 清空被套索选中的元素
  clearSelectedElement() {
    selectedElementList.clear();
  }

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

  /// 菜单相关配置
  MenuConfig menuConfig = MenuConfig();
}
