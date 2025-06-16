import 'package:flutter_excalidraw/type/elementType/stroke_element.dart';

mixin FreedrawModel {
  /// 当前笔画配置
  Map currentOption = Stroke.templateOption;

  /// 当前笔画
  Stroke currentStroke = Stroke();

  /// 重置自由绘画配置
  resetFreeDraw() {
    currentOption = Stroke.templateOption;
    currentStroke = Stroke();
  }
}
