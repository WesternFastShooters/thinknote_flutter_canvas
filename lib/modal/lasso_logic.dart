import 'package:flutter/gestures.dart';
import 'package:flutter_application_2/modal/common_utils.dart';
import 'package:flutter_application_2/modal/white_board_manager.dart';
import 'package:flutter_application_2/type/configType/lasso_config.dart';
import 'package:flutter_application_2/type/elementType/stroke_type.dart';

extension LassoLogic on WhiteBoardManager {
  /// 手势按下触发逻辑
  onLassoPointerDown(PointerDownEvent event) {
    if (currentPointerId != -1) {
      return;
    }
    currentPointerId = event.pointer;
    switch (lassoConfig.lassoStep) {
      case LassoStep.none:
        lassoConfig.lassoStep = LassoStep.drawLine;
        lassoConfig.lassoPathPoints.clear();
        lassoConfig.lassoPathPoints
            .add(transformToCanvasPoint(event.localPosition));
        update();
        return;
      case LassoStep.drawLine:
        return;
      case LassoStep.close:
        if (lassoConfig.lassoPath!
            .contains(transformToCanvasPoint(event.localPosition))) {
          return;
        }
        lassoConfig.lassoStep = LassoStep.none;
        currentToolType = ActionType.transform;
        lassoConfig.lassoPathPoints.clear();
        update();
        return;
    }
  }

  /// 手势平移触发逻辑
  onLassoPointerMove(PointerMoveEvent event) {
    if (event.pointer != currentPointerId) {
      return;
    }
    switch (lassoConfig.lassoStep) {
      case LassoStep.none:
        return;
      case LassoStep.drawLine:
        lassoConfig.lassoPathPoints
            .add(transformToCanvasPoint(event.localPosition));
        update();
        return;
      case LassoStep.close:
        for (var item in selectedElementList) {
          if (item.element.isEmpty) {
            continue;
          }
          item.element.dragOffset += event.delta;
          update();
        }
        return;
    }
  }

  /// 手势提起触发逻辑
  onLassoPointerUp(PointerUpEvent event) {
    if (event.pointer == currentPointerId) {}
    switch (lassoConfig.lassoStep) {
      case LassoStep.none:
        return;
      case LassoStep.drawLine:
        if (event.pointer != currentPointerId) return;
        lassoConfig.lassoStep = LassoStep.close;
        currentPointerId = -1;
        setSelectedElement();
        update();
        return;
      case LassoStep.close:
        return;
    }
  }

  /// 过滤出被套索选中的元素
  setSelectedElement() {
    selectedElementList = canvasElementList
        .where((element) => isIntersecting(
            originPath: lassoConfig.lassoPath!,
            targetPath: (element.element).path))
        .toList();
  }

  /// 清空被套索选中的元素
  clearSelectedElement() {
    selectedElementList.clear();
  }
}
