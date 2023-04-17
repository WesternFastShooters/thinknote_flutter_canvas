import 'package:flutter/gestures.dart';
import 'package:flutter_application_2/modal/utils/geometry_tool.dart';
import 'package:flutter_application_2/type/elementType/element_container.dart';

import '../white_board_manager.dart';

extension FreeDrawGesture on WhiteBoardConfig {
  onFreeDrawPointerDown(PointerDownEvent details) {
    if (currentStroke.isEmpty) {
      setCurrentOption(
          {'simulatePressure': details.kind != PointerDeviceKind.stylus});
      addStrokePoint(
          position: transformToCanvasPoint(details.localPosition),
          pointInfo: details);
    }
  }

  onFreeDrawPointerMove(PointerMoveEvent details) {
    addStrokePoint(
        position: transformToCanvasPoint(details.localPosition),
        pointInfo: details);
  }

  onFreeDrawPointerUp(PointerUpEvent details) {
    canvasElementList.add(ElementContainer(
      element: currentStroke,
      type: ElementType.stroke,
    ));
    resetFreeDraw();
  }
}
