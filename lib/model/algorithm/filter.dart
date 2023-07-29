import 'dart:ui' as ui;
import 'dart:math';
import 'package:flutter_application_2/model/algorithm/alpha_collection.dart';
import 'package:flutter_application_2/model/algorithm/parameterization.dart';



/// 滤波器
class Filter {
  /// 中值滤波
  static List<num> medianFilter(List<num> input, int windowSize) {
    if (windowSize % 2 == 0) {
      windowSize++;
    }
    List<num> output = List<num>.filled(input.length, 0);
    int halfWindow = windowSize ~/ 2;
    for (int i = halfWindow; i < input.length - halfWindow; i++) {
      List<num> window = input.sublist(i - halfWindow, i + halfWindow + 1);
      window.sort();
      output[i] = window[halfWindow];
    }
    return output;
  }

  /// 获取中指滤波器窗口
  static int getMedianFilterWindowSize(num windowSize) {
    if (windowSize < 1) {
      return 1;
    } else {
      int windowSizeInt = windowSize.toInt();
      if (windowSizeInt % 2 == 0) {
        return windowSizeInt + 1;
      } else {
        return windowSizeInt;
      }
    }
  }

  static List<num> gaussianFilter(List<num> data, num sigma) {
    List<num> kernel = [];
    int size = (sigma * 3).ceil() * 2 + 1;
    num sum = 0;
    for (var i = 0; i < size; i++) {
      num x = i - (size ~/ 2);
      num value = exp(-(x * x) / (2 * sigma * sigma));
      kernel.add(value);
      sum += value;
    }
    for (int i = 0; i < size; i++) {
      kernel[i] /= sum;
    }
    List<num> result = [];
    for (var i = 0; i < data.length; i++) {
      num value = 0;
      for (var j = 0; j < size; j++) {
        int index = i + j - size ~/ 2;
        if (index >= 0 && index < data.length) {
          value += data[index] * kernel[j];
        }
      }
      result.add(value);
    }
    return result;
  }

  /// 去噪声
  static List<ui.Offset> denoise(List<ui.Offset> initialData) {
    List<AlphaCollection> preTransformedData =
        Parameterization.preTransform(initialData);
    List<num> medfiltedData = Filter.medianFilter(
        preTransformedData.map((item) => item.alpha).toList(),
        Filter.getMedianFilterWindowSize(preTransformedData.length * 0.1));

    List<num> gaussianedData = Filter.gaussianFilter(medfiltedData, 0.5);

    for (var i = 0; i < preTransformedData.length; i++) {
      preTransformedData[i].alpha = gaussianedData[i];
    }
    var newArr =
        Parameterization.backTransform(preTransformedData, initialData[0]);
    return newArr;
  }
}
