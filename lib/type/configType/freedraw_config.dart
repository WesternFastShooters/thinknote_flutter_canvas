import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/type/elementType/stroke_type.dart';

class FreedrawConfig {

  Map currentOption = {
    'size': 3.0,
    'thinning': 0.1,
    'smoothing': 0.5,
    'streamline': 0.5,
    'taperStart': 0.0,
    'capStart': true,
    'taperEnd': 0.1,
    'capEnd': true,
    'simulatePressure': true,
    'isComplete': false,
    'color': Colors.green,
  };

  Stroke currentStroke = Stroke.init();
}
