import 'package:flutter/gestures.dart';
import '../white_board_manager.dart';

extension FreeDrawGesture on WhiteBoardManager {
  onFreeDrawPointerDown(PointerDownEvent details) {
    if (whiteBoardModel.currentStroke.isEmpty) {
      whiteBoardModel.currentStroke
        ..setOption({
          ...whiteBoardModel.currentOption,
          'simulatePressure': details.kind != PointerDeviceKind.stylus
        })
        ..addStrokePoint(
            position: whiteBoardModel.transformToCanvasPoint(details.localPosition),
            pointInfo: details);
    }
  }

  onFreeDrawPointerMove(PointerMoveEvent details) {
    whiteBoardModel.currentStroke.addStrokePoint(
        position: whiteBoardModel.transformToCanvasPoint(details.localPosition),
        pointInfo: details);
  }

  onFreeDrawPointerUp(PointerUpEvent details) {
    whiteBoardModel.canvasElementList
        .add(whiteBoardModel.currentStroke.complete());
    whiteBoardModel.resetFreeDraw();
  }
}
