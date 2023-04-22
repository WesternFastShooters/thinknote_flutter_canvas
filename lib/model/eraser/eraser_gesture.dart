import 'package:flutter/cupertino.dart';

import '../white_board_manager.dart';

extension EraserGesture on WhiteBoardManager {
  onEraserPointerDown(PointerDownEvent details) {
    if (whiteBoardModel.currentEraserPosition == null) {
      whiteBoardModel.setCurrentEraserPosition(details.localPosition);
      whiteBoardModel.erase();
    }
  }

  onEraserPointerMove(PointerMoveEvent details) {
    whiteBoardModel.setCurrentEraserPosition(details.localPosition);
    whiteBoardModel.erase();
  }

  onEraserPointerUp(PointerUpEvent details) {
    whiteBoardModel.currentEraserPosition = null;
  }
}
