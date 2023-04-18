import 'package:flutter/gestures.dart';
import 'package:flutter_application_2/modal/lasso/lasso_function.dart';
import 'package:flutter_application_2/modal/utils/geometry_tool.dart';
import 'package:flutter_application_2/type/elementType/whiteboard_element.dart';

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
          translateClosedShape(offset: event.delta);
          for (var item in selectedElementList) {
            if (item.isEmpty) {
              continue;
            }
            item.translateElement(
                offset: event.delta, mode: MoveElementMode.drag);
          }
          break;
        }
    }
  }

  /// 手势提起触发逻辑
  onLassoPointerUp(PointerUpEvent event) {
    switch (lassoStep) {
      case LassoStep.drawLine:
        completeDashesLine();
        if (!isDashesLineEmpty) {
          setSelectedElement();
        }
        if (selectedElementList.isEmpty) {
          resetLassoConfig();
        }
        setLassoStep(LassoStep.close);
        break;
      case LassoStep.close:
        break;
    }
  }
}
