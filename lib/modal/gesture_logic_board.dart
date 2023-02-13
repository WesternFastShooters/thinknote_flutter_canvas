import 'package:flutter/cupertino.dart';
import 'package:flutter_application_2/modal/board_modal.dart';

import '../constant/canva_id.dart';

extension GestureLogicBoard on BoardModal {
  void onPointerMove(PointerMoveEvent event) {
    curCanvasOffset += event.localDelta;
    update([CanvasID.backgroundLayerWidgetId, CanvasID.rectLayerWidgetID]);
  }
}
