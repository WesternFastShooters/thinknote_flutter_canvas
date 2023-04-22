import 'package:flutter/material.dart';
import 'package:flutter_application_2/model/white_board_manager.dart';
import '../../type/elementType/whiteboard_element.dart';

enum LassoStep {
  /// 画线
  drawLine,

  /// 闭合
  close,
}

mixin LassoModel on WhiteBoardInfo, WhiteBoardGeometry {
  /// 套索行为阶段
  LassoStep lassoStep = LassoStep.drawLine;

  /// 套索的路径点
  List<Offset> lassoPathPointList = [];

  /// 是否处于拖拽状态
  bool isDrag = false;

  /// 平移套索闭合区域
  translateClosedShape({required Path lasso,required Offset offset}) {
    if (lassoPathPointList.isNotEmpty) {
      this.lasso = Path.from(lasso);
      lassoPathPointList.clear();
    }
    final matrix4 = Matrix4.identity()..translate(offset.dx, offset.dy);
    this.lasso = lasso.transform(matrix4.storage);
  }

  /// 路径绘制样式
  Paint get paint => Paint()
    ..color = Colors.blue
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke
    ..isAntiAlias = true
    ..strokeJoin = StrokeJoin.miter;

  /// 套索路径
  Path _lasso = Path();
  set lasso(Path path) {
    _lasso = path;
  }

  Path get lasso {
    switch (lassoStep) {
      case LassoStep.drawLine:
        Path path = Path();
        lassoPathPointList.asMap().forEach((index, point) {
          if (index == 0) {
            path.moveTo(point.dx, point.dy);
          } else {
            path.lineTo(point.dx, point.dy);
          }
        });
        return path;
      case LassoStep.close:
        if (lassoPathPointList.isNotEmpty && lassoPathPointList.length > 2) {
          Path path = Path();
          lassoPathPointList.asMap().forEach((index, point) {
            if (index == 0) {
              path.moveTo(point.dx, point.dy);
            } else {
              path.lineTo(point.dx, point.dy);
            }
          });
          path.close();
          return path;
        } else {
          return _lasso;
        }
    }
  }

  /// 存储选中的元素集合
  List<WhiteBoardElement> get selectedElementList => canvasElementList
      .where((element) =>
          isIntersecting(originPath: lasso, targetPath: element.path))
      .toList();

  /// 获取所框选图形集合的中心
  Offset get selectedElementCenter =>
      lassoStep == LassoStep.close ? lasso.getBounds().center : Offset.zero;

  /// 检查是否命中套索区域内
  bool isHitLassoCloseArea(Offset position) => lasso.contains(position);

  /// 添加套索虚线点
  addLassoPathPoint(Offset point) {
    lassoPathPointList.add(point);
  }

  /// 设置套索行为阶段
  setLassoStep(LassoStep step) {
    lassoStep = step;
  }

  /// 重置套索配置
  resetLassoConfig() {
    lassoStep = LassoStep.drawLine;
    lassoPathPointList.clear();
  }
}
