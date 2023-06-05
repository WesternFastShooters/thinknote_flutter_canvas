import 'dart:ui' as ui;
import 'package:flutter/gestures.dart';
import 'package:flutter_application_2/model/element/shape.dart';
import 'package:flutter_application_2/model/element/stroke.dart';

enum ActionType {
  /// 自由绘画模式
  freeDraw,

  /// 平移或缩放画布模式
  hand,

  /// 橡皮擦模式
  eraser,

  /// 套索模式
  lasso,
}

mixin CanvasStore {
  /// 当前选用工具类型（默认为平移缩放）
  ActionType currentToolType = ActionType.hand;

  /// 所有画迹
  List<Stroke> strokeList = [];

  /// 所有几何元素
  List<Shape> shapeList = [];

  /// 框选区
  SelectedArea selectedArea = SelectedArea();

  /// 暂存区
  CasheArea casheArea = CasheArea();

  // 画布的偏移量
  ui.Offset canvasOffset = ui.Offset.zero;

  // 画布当前的缩放比例
  double canvasScale = 1.0;

  /// 根据传入的坐标映射为canvas的坐标
  ui.Offset transformToCanvasOffset(
    ui.Offset currentPosition,
  ) =>
      ((currentPosition - canvasOffset) / canvasScale);
}

extension StoreAction on CanvasStore {
  /// 暂存所选元素
  _casheSelectedElement() {
    casheArea.casheStrokeList =
        selectedArea.selectedStrokeList.map((item) => item.copy()).toList();
    // casheArea.casheShapeList = selectedArea.selectedShapeList;
    casheArea.casheTrackPath = ui.Path.from(selectedArea.trackPath);
  }

  /// 复制所选元素
  copySelectedElement() {
    _casheSelectedElement();
  }

  /// 剪切所选元素
  cutSelectedElement() {
    _casheSelectedElement();
    deleteSelectedElement();
  }

  /// 粘贴所选元素
  pasteSelectedElement(newPosition) {
    Offset distance = newPosition - casheArea.center;
    strokeList.addAll(casheArea.casheStrokeList
        .map((item) => item.copy()..translate(distance))
        .toList());
    // TODO: 未实现几何元素的复制
    selectedArea.selectedStrokeList = casheArea.casheStrokeList
        .map((item) => item.copy()..translate(distance))
        .toList();
    final matrix4 = Matrix4.identity()..translate(distance.dx, distance.dy);
    selectedArea.trackPath = casheArea.casheTrackPath.transform(matrix4.storage);
  }

  /// 删除所选元素
  deleteSelectedElement() {
    strokeList.removeWhere((strokeItem) => selectedArea.selectedStrokeList.any(
        (selectedStrokeItem) => identical(strokeItem, selectedStrokeItem)));
    // TODO: 未实现几何元素的删除
    selectedArea.selectedStrokeList.clear();
    selectedArea.trackPath.reset();
  }
}

class SelectedArea {
  List<Stroke> selectedStrokeList = []; // 选中的画迹
  List<Shape> selectedShapeList = []; // 选中的几何元素
  ui.Path trackPath = ui.Path(); // 选中的轨迹

  bool get hasSelectedContent =>
      selectedStrokeList.isNotEmpty || selectedShapeList.isNotEmpty;

  ui.Offset get center => trackPath.getBounds().center;
}

class CasheArea {
  List<Stroke> casheStrokeList = [];
  List<Shape> casheShapeList = [];
  ui.Path casheTrackPath = ui.Path();

  bool get hasCasheContent =>
      casheStrokeList.isNotEmpty || casheShapeList.isNotEmpty;

  ui.Offset get center => casheTrackPath.getBounds().center;
}
