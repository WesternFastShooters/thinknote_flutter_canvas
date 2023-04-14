import 'package:flutter/gestures.dart';
import 'package:flutter_application_2/modal/common_utils.dart';
import 'package:flutter_application_2/modal/white_board_manager.dart';
import 'package:flutter_application_2/type/elementType/stroke_type.dart';
import 'package:flutter_application_2/type/elementType/element_container.dart';

extension FreeDrawLogic on WhiteBoardManager {
  onFreeDrawPointerDown(PointerDownEvent details) {
    if (freedrawConfig.currentStroke.isEmpty) {
      freedrawConfig.setCurrentOption(
          {'simulatePressure': details.kind != PointerDeviceKind.stylus});
      freedrawConfig.addStrokePoint(
          position: transformToCanvasPoint(details.localPosition),
          pointInfo: details);

      update();
    }
  }

  onFreeDrawPointerMove(PointerMoveEvent details) {
    freedrawConfig.addStrokePoint(
        position: transformToCanvasPoint(details.localPosition),
        pointInfo: details);
    update();
  }

  onFreeDrawPointerUp(PointerUpEvent details) {
    canvasElementList.add(ElementContainer(
      element: freedrawConfig.currentStroke,
      type: ElementType.stroke,
    ));
    freedrawConfig.reset();
    update();
  }
}
