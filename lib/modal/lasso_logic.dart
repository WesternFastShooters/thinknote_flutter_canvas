import 'package:flutter/gestures.dart';
import 'package:flutter_application_2/modal/common_utils.dart';
import 'package:flutter_application_2/modal/white_board_manager.dart';
import 'package:flutter_application_2/type/configType/lasso_config.dart';
import 'package:flutter_application_2/type/elementType/stroke_type.dart';

extension LassoLogic on WhiteBoardManager {
  /// 手势按下触发逻辑
  onLassoPointerDown(PointerDownEvent event) {
    currentPointerId = event.pointer;
    switch (lassoConfig.lassoStep) {
      case LassoStep.drawLine:
        lassoConfig.setLassoStep(LassoStep.drawLine);
        lassoConfig.reset();
        lassoConfig
            .addLassoPathPoint(transformToCanvasPoint(event.localPosition));
        update();
        break;
      case LassoStep.close:
        if (lassoConfig.checkHitLassoCloseArea(
            transformToCanvasPoint(event.localPosition))) {
          // 命中套索区域内情况
          // 不进行任何操作
          break;
        }
        // 不命中套索区域内情况
        lassoConfig.reset();
        update();
    }
  }

  /// 手势平移触发逻辑
  onLassoPointerMove(PointerMoveEvent event) {
    switch (lassoConfig.lassoStep) {
      case LassoStep.drawLine:
        lassoConfig
            .addLassoPathPoint(transformToCanvasPoint(event.localPosition));
        update();
        break;
      case LassoStep.close:
        if (lassoConfig.checkHitLassoCloseArea(
            transformToCanvasPoint(event.localPosition))) {
          lassoConfig.setDragOffset(event.delta);
          for (var item in selectedElementList) {
            if (item.element.isEmpty) {
              continue;
            }
            item.element.setDragOffset(event.delta);
            update();
          }
          break;
        }
    }
  }

  /// 手势提起触发逻辑
  onLassoPointerUp(PointerUpEvent event) {
    
    switch (lassoConfig.lassoStep) {
      case LassoStep.drawLine:
        lassoConfig.setLassoStep(LassoStep.close);
        if (!lassoConfig.isEmpty) {
          setSelectedElement();
        }
        if (selectedElementList.isEmpty) {
          lassoConfig.reset();
        }
        break;
      case LassoStep.close:
        break;
    }
    
    update();
  }

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
}
