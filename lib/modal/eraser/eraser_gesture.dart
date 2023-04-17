import 'package:flutter/cupertino.dart';
import 'package:flutter_application_2/modal/eraser/eraser_function.dart';
import 'package:flutter_application_2/modal/utils/geometry_tool.dart';

import '../white_board_manager.dart';

extension EraserGesture on WhiteBoardConfig {
  onEraserPointerDown(PointerDownEvent details) {
    if (currentEraserPosition == null) {
      currentEraserPosition = transformToCanvasPoint(details.localPosition);
      erase();
    }
  }

  onEraserPointerMove(PointerMoveEvent details) {
    currentEraserPosition = transformToCanvasPoint(details.localPosition);
    erase();
  }

  onEraserPointerUp(PointerUpEvent details) {
    currentEraserPosition = null;
  }
}
