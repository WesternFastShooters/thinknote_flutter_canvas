import 'package:flutter/gestures.dart';
import 'package:flutter_application_2/modal/common_utils.dart';
import 'package:flutter_application_2/modal/white_board_manager.dart';

extension MenuLogic on WhiteBoardManager {
  /// 长按按下触发逻辑
  onLongPressDown(LongPressDownDetails details) {
    // switch (currentToolType.value) {
    //   case ActionType.transform:
    //     menuConfig.showMenu(
    //         menuPosition: transformToCanvasPoint(details.localPosition),
    //         isShowMenu: true,
    //         menuItems: ['粘贴']);
    //     break;
    //   case ActionType.lasso:
    //     menuConfig.showMenu(
    //         menuPosition: transformToCanvasPoint(details.localPosition),
    //         isShowMenu: true,
    //         menuItems: ['复制', '粘贴', '删除', '粘贴']);
    //     break;
    // }
  }
}
