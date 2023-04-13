import 'package:flutter/gestures.dart';
import 'package:flutter_application_2/modal/common_utils.dart';
import 'package:flutter_application_2/modal/white_board_manager.dart';
import 'package:flutter_application_2/type/elementType/stroke_type.dart';
import 'package:flutter_application_2/type/elementType/element_container.dart';

extension FreeDrawLogic on WhiteBoardManager {
  onFreeDrawPointerDown(PointerDownEvent details) {
    if (freedrawConfig.currentStroke.isEmpty && currentPointerId == -1) {
      freedrawConfig.currentOption['simulatePressure'] =
          details.kind != PointerDeviceKind.stylus;
      freedrawConfig.currentStroke.storeStrokePoint(
          position: transformToCanvasPoint(details.localPosition),
          pointInfo: details);
      currentPointerId = details.pointer;
      update();
    }
  }

  onFreeDrawPointerMove(PointerMoveEvent details) {
    if (details.pointer == currentPointerId) {
      freedrawConfig.currentStroke.storeStrokePoint(
          position: transformToCanvasPoint(details.localPosition),
          pointInfo: details);
      update();
    }
  }

  onFreeDrawPointerUp(PointerUpEvent details) {
    if (details.pointer == currentPointerId) {
      canvasElementList.add(ElementContainer(
        element: freedrawConfig.currentStroke,
        type: ElementType.stroke,
      ));
      freedrawConfig.currentStroke = Stroke.init();
      currentPointerId = -1;
      update();
    }
  }
}
