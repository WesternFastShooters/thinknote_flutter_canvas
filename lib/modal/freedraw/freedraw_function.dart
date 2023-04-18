import 'package:flutter_application_2/type/elementType/stroke_element.dart';

import '../white_board_manager.dart';

extension FreeDrawFuction on WhiteBoardConfig {


  /// 重置自由绘画配置
  resetFreeDraw() {
    currentOption = Stroke.templateOption;
    currentStroke = Stroke();
  }
}
