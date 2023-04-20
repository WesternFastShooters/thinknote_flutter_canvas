import 'package:flutter/gestures.dart';
import 'package:flutter_application_2/modal/freedraw/freedraw_function.dart';
import 'package:flutter_application_2/modal/utils/geometry_tool.dart';
import '../white_board_manager.dart';

extension FreeDrawGesture on WhiteBoardManager {
  onFreeDrawPointerDown(PointerDownEvent details) {
    if (whiteBoardConfig.currentStroke.isEmpty) {
      whiteBoardConfig.currentStroke
        ..setOption({
          ...whiteBoardConfig.currentOption,
          'simulatePressure': details.kind != PointerDeviceKind.stylus
        })
        ..addStrokePoint(
            position: transformToCanvasPoint(details.localPosition),
            pointInfo: details);
    }
  }

  onFreeDrawPointerMove(PointerMoveEvent details) {
    whiteBoardConfig.currentStroke.addStrokePoint(
        position: transformToCanvasPoint(details.localPosition),
        pointInfo: details);
  }

  onFreeDrawPointerUp(PointerUpEvent details) {
    whiteBoardConfig.canvasElementList
        .add(whiteBoardConfig.currentStroke.complete());
    resetFreeDraw();
  }
}
