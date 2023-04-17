import 'package:flutter/gestures.dart';
import 'package:flutter_application_2/modal/utils/geometry_tool.dart';

import 'package:flutter_application_2/type/elementType/stroke_type.dart';

import '../white_board_manager.dart';

extension FreeDrawFuction on WhiteBoardConfig {
  /// 为当前笔画添加画迹点
  addStrokePoint(PointerEvent details) {
    final position = transformToCanvasPoint(details.localPosition);
    final StrokePoint point = details.kind == PointerDeviceKind.stylus
        ? StrokePoint(
            position.dx,
            position.dy,
            (details.pressure - details.pressureMin) /
                (details.pressureMax - details.pressureMin),
          )
        : StrokePoint(position.dx, position.dy);
    currentStroke.strokePoints.add(point);
  }

  /// 设置当前笔画配置
  setCurrentOption(Map option) {
    currentOption = {
      ...currentOption,
      ...option,
    };
  }

}
