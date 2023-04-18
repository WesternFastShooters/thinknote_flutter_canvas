import 'dart:ui';

import 'package:flutter_application_2/modal/utils/geometry_tool.dart';

import '../white_board_manager.dart';
import 'lasso_config.dart';

extension LassoFunction on WhiteBoardConfig {
  /// 过滤出被套索选中的元素
  setSelectedElement() {
    selectedElementList = canvasElementList
        .where((element) => isIntersecting(
            originPath: closedShapePath!, targetPath: element.path))
        .toList();
  }

  /// 检查是否命中套索区域内
  bool isHitLassoCloseArea(Offset position) =>
      isEmpty ? false : closedShapePath!.contains(position);

  /// 添加套索虚线点
  addLassoPathPoint(Offset point) {
    lassoPathPoints.add(point);
  }

  /// 设置套索行为阶段
  setLassoStep(LassoStep step) {
    lassoStep = step;
  }

  /// 重置套索配置
  resetLassoConfig() {
    lassoStep = LassoStep.drawLine;
    lassoPathPointList.clear();
    dragOffset = Offset.zero;
    selectedElementList.clear;
  }

  /// 获取所框选图形集合的中心
  Offset getSelectedElementCenter(List<Path> pathList) {
    var center = Offset.zero;
    Rect bounds = Rect.zero;
    for (var path in pathList) {
      bounds = bounds.expandToInclude(path.getBounds());
    }
    center = bounds.center;
    return center;
  }
}
