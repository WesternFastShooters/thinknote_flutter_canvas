import 'package:flutter/gestures.dart';
import 'package:flutter_application_2/modal/freedraw/freedraw_function.dart';
import 'package:flutter_application_2/modal/utils/geometry_tool.dart';
import '../white_board_manager.dart';

extension FreeDrawGesture on WhiteBoardConfig {
  onFreeDrawPointerDown(PointerDownEvent details) {
    if (currentStroke.isEmpty) {
      currentStroke
        ..setOption({
          ...currentOption,
          'simulatePressure': details.kind != PointerDeviceKind.stylus
        })
        ..addStrokePoint(
            position: transformToCanvasPoint(details.localPosition),
            pointInfo: details);
    }
  }

  onFreeDrawPointerMove(PointerMoveEvent details) {
    currentStroke.addStrokePoint(
        position: transformToCanvasPoint(details.localPosition),
        pointInfo: details);
  }

  onFreeDrawPointerUp(PointerUpEvent details) {
    canvasElementList.add(currentStroke.complete());
    resetFreeDraw();
  }
}
