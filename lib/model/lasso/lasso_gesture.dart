import 'package:flutter/gestures.dart';

import '../white_board_manager.dart';
import 'lasso_model.dart';

extension LassoGesture on WhiteBoardManager {
  /// 手势按下触发逻辑
  onLassoPointerDown(PointerDownEvent event) {
    switch (whiteBoardModel.lassoStep) {
      case LassoStep.drawLine:
        whiteBoardModel.addLassoPathPoint(
            whiteBoardModel.transformToCanvasPoint(event.localPosition));
        break;
      case LassoStep.close:
        if (whiteBoardModel.isHitLassoCloseArea(
            whiteBoardModel.transformToCanvasPoint(event.localPosition))) {
          whiteBoardModel.isDrag = true;
          break;
        }
        whiteBoardModel.resetLassoConfig();
        break;
    }
  }

  /// 手势平移触发逻辑
  onLassoPointerMove(PointerMoveEvent event) {
    switch (whiteBoardModel.lassoStep) {
      case LassoStep.drawLine:
        whiteBoardModel.addLassoPathPoint(
            whiteBoardModel.transformToCanvasPoint(event.localPosition));
        break;
      case LassoStep.close:
        for (var item in whiteBoardModel.selectedElementList) {
          if (item.isEmpty) {
            continue;
          }
          item.translateElement(event.delta);
        }
        whiteBoardModel.translateClosedShape(
            lasso: whiteBoardModel.lasso, offset: event.delta);
        break;
    }
    update();
  }

  /// 手势提起触发逻辑
  onLassoPointerUp(PointerUpEvent event) {
    switch (whiteBoardModel.lassoStep) {
      case LassoStep.drawLine:
        whiteBoardModel.setLassoStep(LassoStep.close);
        whiteBoardModel.setSelectedElementList();
        if (whiteBoardModel.selectedElementList.isEmpty) {
          whiteBoardModel.resetLassoConfig();
        }
        break;
      case LassoStep.close:
        whiteBoardModel.isDrag = false;
        break;
    }
    update();
  }
}
