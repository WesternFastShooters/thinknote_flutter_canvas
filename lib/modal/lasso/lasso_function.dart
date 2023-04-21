import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter_application_2/modal/utils/geometry_tool.dart';

import '../white_board_manager.dart';
import 'lasso_config.dart';

extension LassoFunction on WhiteBoardManager {
  /// 过滤出被套索选中的元素
  setSelectedElement() {
    whiteBoardConfig.selectedElementList = whiteBoardConfig.canvasElementList
        .where((element) => isIntersecting(
            originPath: whiteBoardConfig.closedShapePath,
            targetPath: element.path))
        .toList();
  }

  /// 检查是否命中套索区域内
  bool isHitLassoCloseArea(Offset position) =>
      whiteBoardConfig.closedShapePath.contains(position);

  /// 添加套索虚线点
  addLassoPathPoint(Offset point) {
    whiteBoardConfig.lassoPathPointList.add(point);
  }

  /// 设置套索行为阶段
  setLassoStep(LassoStep step) {
    whiteBoardConfig.lassoStep = step;
  }

  /// 重置套索配置
  resetLassoConfig() {
    whiteBoardConfig.lassoStep = LassoStep.drawLine;
    whiteBoardConfig.lassoPathPointList.clear();
    whiteBoardConfig.dragLassoOffset = Offset.zero;
    whiteBoardConfig.selectedElementList.clear;
  }

  /// 获取所框选图形集合的中心
  Offset getSelectedElementCenter() {
    return whiteBoardConfig.closedShapePath.getBounds().center;
  }

  Path getClosedShapePath(List<Offset> lassoPathPointLis) {
    final path = Path();
    if (lassoPathPointLis.length < 2) {
      return path;
    }
    path.moveTo(lassoPathPointLis[0].dx, lassoPathPointLis[0].dy);
    for (var i = 1; i < lassoPathPointLis.length; i++) {
      path.lineTo(lassoPathPointLis[i].dx, lassoPathPointLis[i].dy);
    }
    path.close();
    return path;
  }

  completeDashesLine() {
    whiteBoardConfig.closedShapePath =
        getClosedShapePath(whiteBoardConfig.lassoPathPointList);
    setSelectedElement();
    if (whiteBoardConfig.selectedElementList.isEmpty) {
      resetLassoConfig();
    }
    whiteBoardConfig.lassoPathPointList.clear();
  }

  translateClosedShape(Offset offset) {
    final matrix4 = Matrix4.identity()..translate(offset.dx, offset.dy);
    whiteBoardConfig.closedShapePath =
        whiteBoardConfig.closedShapePath.transform(matrix4.storage);
  }
}
