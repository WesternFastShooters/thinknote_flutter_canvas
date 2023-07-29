import 'dart:math';
import "dart:ui" as ui;
import 'package:flutter_application_2/model/algorithm/alpha_collection.dart';
import 'package:vector_math/vector_math.dart';

/// 参数化方法类
class Parameterization {
  /// 正向转换
  static List<AlphaCollection> preTransform(List<ui.Offset> offsets) {
    List<AlphaCollection> result = [];
    for (var i = 0; i < offsets.length - 1; i++) {
      // 计算差向量
      var delta = Vector2(
          offsets[i + 1].dx - offsets[i].dx, offsets[i + 1].dy - offsets[i].dy);
      // 计算长度
      double length = delta.length;
      // 计算r向量
      var r = delta / length;
      // 计算alpha角度
      double alpha = atan2(r.y, r.x);
      // 将结果保存到字典中
      result.add(AlphaCollection(alpha, length));
    }
    return result;
  }

  /// 反向转换
  static List<ui.Offset> backTransform(
      List<AlphaCollection> data, ui.Offset initialPoint) {
    List<ui.Offset> result = [initialPoint];
    for (var i = 0; i < data.length; i++) {
      var alpha = data[i].alpha;
      var length = data[i].lenght;
      var curPoint = result.last;
      var nextPoint =
          curPoint + ui.Offset(length * cos(alpha), length * sin(alpha));
      result.add(nextPoint);
    }
    return result;
  }
}
