import 'package:flutter/gestures.dart';
import 'package:flutter_application_2/modal/lasso/lasso_function.dart';
import 'package:flutter_application_2/modal/utils/geometry_tool.dart';

import '../white_board_manager.dart';
import 'lasso_config.dart';

extension LassoGesture on WhiteBoardConfig {
  /// 手势按下触发逻辑
  onLassoPointerDown(PointerDownEvent event) {
    switch (lassoStep) {
      case LassoStep.drawLine:
        setLassoStep(LassoStep.drawLine);
        resetLassoConfig();
        addLassoPathPoint(transformToCanvasPoint(event.localPosition));

        break;
      case LassoStep.close:
        if (isHitLassoCloseArea(transformToCanvasPoint(event.localPosition))) {
          // 命中套索区域内情况,不进行任何操作
          break;
        }
        // 不命中套索区域内情况,重置套索配置
        resetLassoConfig();
        break;
    }
  }

  /// 手势平移触发逻辑
  onLassoPointerMove(PointerMoveEvent event) {
    switch (lassoStep) {
      case LassoStep.drawLine:
        addLassoPathPoint(transformToCanvasPoint(event.localPosition));
        break;
      case LassoStep.close:
        if (isHitLassoCloseArea(transformToCanvasPoint(event.localPosition))) {
          setDragOffset(event.delta);
          for (var item in selectedElementList) {
            if (item.element.isEmpty) {
              continue;
            }
            item.element.setDragOffset(event.delta);
          }
          break;
        }
    }
  }

  /// 手势提起触发逻辑
  onLassoPointerUp(PointerUpEvent event) {
    switch (lassoStep) {
      case LassoStep.drawLine:
        setLassoStep(LassoStep.close);
        if (!isEmpty) {
          setSelectedElement();
        }
        if (selectedElementList.isEmpty) {
          // 未选中任何元素，则重置套索配置
          resetLassoConfig();
        }
        break;
      case LassoStep.close:
        break;
    }
  }
}
