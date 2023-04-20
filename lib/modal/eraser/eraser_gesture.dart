import 'package:flutter/cupertino.dart';
import 'package:flutter_application_2/modal/eraser/eraser_function.dart';
import 'package:flutter_application_2/modal/utils/geometry_tool.dart';

import '../white_board_manager.dart';

extension EraserGesture on WhiteBoardManager {
  onEraserPointerDown(PointerDownEvent details) {
    if (whiteBoardConfig.currentEraserPosition == null) {
      whiteBoardConfig.currentEraserPosition =
          transformToCanvasPoint(details.localPosition);
      erase();
    }
    update();
  }

  onEraserPointerMove(PointerMoveEvent details) {
    whiteBoardConfig.currentEraserPosition =
        transformToCanvasPoint(details.localPosition);
    erase();
    update();
  }

  onEraserPointerUp(PointerUpEvent details) {
    whiteBoardConfig.currentEraserPosition = null;
    update();
  }
}
