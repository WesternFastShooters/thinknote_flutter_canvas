import 'package:flutter/gestures.dart';
import 'package:flutter_application_2/modal/common_utils.dart';
import 'package:flutter_application_2/modal/transform_logic.dart';
import 'package:flutter_application_2/modal/white_board_manager.dart';
import 'package:flutter_application_2/type/configType/lasso_config.dart';
import 'package:flutter_application_2/type/elementType/element_container.dart';

extension LassoLogic on WhiteBoardManager {
  /// 手势按下触发逻辑
  onLassoPointerDown(PointerDownEvent event) {
    if (currentPointerId == -1) {
      currentPointerId = event.pointer;
      lassoConfig.lassoStep = LassoStep.drawLine;
      lassoConfig.lassoPathPoints.clear();
      lassoConfig.lassoPathPoints
          .add(transformToCanvasPoint(event.localPosition));
      update();
    }
  }

  /// 手势平移触发逻辑
  onLassoPointerMove(PointerMoveEvent event) {
    if (event.pointer == currentPointerId) {
      lassoConfig.lassoPathPoints
          .add(transformToCanvasPoint(event.localPosition));
      update();
    }
  }

  /// 手势提起触发逻辑
  onLassoPointerUp(PointerUpEvent event) {
    if (event.pointer == currentPointerId) {
      lassoConfig.lassoStep = LassoStep.close;
      currentPointerId = -1;
      update();
    }
  }

  _setSelectedElement(){
    canvasElementList.forEach((element) {
      if (element.type == ElementType.stroke) {
        element.isSelected = isIntersecting(
            originPath: lassoConfig.lassoPath,
            targetPath: (element.element as Stroke).path);
      }
    });
  }
}
