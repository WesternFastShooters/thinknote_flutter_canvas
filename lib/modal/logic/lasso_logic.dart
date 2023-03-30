import 'package:flutter/material.dart';
import 'package:flutter_application_2/modal/board_modal.dart';
import '../../constants/tool_type.dart';

extension LassoLogic on BoardModal {
  /// 手势按下触发逻辑
  // 添加当前手势的起始点到套索点集合lassoPoints中，最后调用updata()方法更新视图
  execPointerDownForLasso(PointerDownEvent event) {
    if (currentToolType != ToolType.lasso) {
      return;
    }
    currentLassoPoints.add(transformToCanvasPoint(event.localPosition));
    update();
  }

  /// 手势移动触发逻辑
  // 添加当前手势的移动点到套索点集合lassoPoints中，最后调用updata()方法更新视图
  execPointerMoveForLasso(PointerMoveEvent event) {
    if (currentToolType != ToolType.lasso) {
      return;
    }
    currentLassoPoints.add(transformToCanvasPoint(event.localPosition));
    update();
  }

  /// 手势抬起触发逻辑
  // 将drawingLassoPoints 中的点移至lassoPoints中，并清空drawingLassoPoints，最后调用updata()方法更新视图
  execPointerUpForLasso(PointerUpEvent event) {
    if (currentToolType != ToolType.lasso) {
      return;
    }
    closedShapePolygonPoints.addAll(currentLassoPoints);
    currentLassoPoints.clear();
    update();
  }
}
