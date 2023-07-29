import 'dart:ui' as ui;
import 'package:flutter_application_2/model/algorithm/curvature_collection.dart';
import 'package:flutter_application_2/model/algorithm/filter.dart';
import 'package:flutter_application_2/model/algorithm/geometry_algorithm.dart';
import 'package:flutter_application_2/model/extension/path_extension.dart';

class ShapeRecognition {
  static recognize(ui.Path path) {
    List<ui.Offset> offsets = path.toBePoints();
    List<ui.Offset> handledOffsets = getHandledPoint(offsets);
    List<CurvatureCollection> curvatureCollectionList =
        GeometryAlgorithm().getCurvatureCollectionList(handledOffsets);
    var arr = curvatureCollectionList.map((e) => e.curvature).toList();
    num maxNum =
        arr.reduce((value, element) => value > element ? value : element);
    print("最大值是：$maxNum");
  }

  /// 获取处理后的Path
  static List<ui.Offset> getHandledPoint(List<ui.Offset> offsets) {
    try {
      List<ui.Offset> denoisedData = Filter.denoise(offsets);
      List<ui.Offset> handledData = handleCurvePoint(denoisedData);
      return handledData;
    } catch (error) {
      return offsets;
    }
  }

  /// 处理曲线的点坐标集合
  static List<ui.Offset> handleCurvePoint(List<ui.Offset> offsets) {
    List<ui.Offset> intersectionPoint =
        GeometryAlgorithm.getIntersectionPoint(offsets);
    if (intersectionPoint.isEmpty) {
      return offsets;
    } else if (intersectionPoint.length == 1) {
      return closeCurve(intersectionPoint, offsets);
    } else {
      throw Exception("有大于1个的相交点");
    }
  }

  /// 将曲线闭合
  static closeCurve(
      List<ui.Offset> intersectionPoint, List<ui.Offset> offsets) {
    var duplicatePointIndexHead = offsets.indexOf(intersectionPoint[0]);
    var duplicatePointIndexEnd = offsets.indexOf(intersectionPoint[1]);
    var midPoint = ui.Offset(
        (offsets[duplicatePointIndexHead].dx +
                offsets[duplicatePointIndexEnd].dx) /
            2,
        (offsets[duplicatePointIndexHead].dy +
                offsets[duplicatePointIndexEnd].dy) /
            2);
    offsets[duplicatePointIndexHead] = midPoint;
    offsets[duplicatePointIndexEnd] = midPoint;
    if ((duplicatePointIndexHead + 1) / offsets.length < 0.001 &&
        (offsets.length - (duplicatePointIndexEnd + 1)) / offsets.length <
            0.001) {
      return offsets.sublist(
          duplicatePointIndexHead, duplicatePointIndexEnd + 1);
    } else {
      throw Exception("存在多余的环");
    }
  }
}
