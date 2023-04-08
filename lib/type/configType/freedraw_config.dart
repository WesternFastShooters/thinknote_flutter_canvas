import 'dart:ui';
import 'package:flutter/material.dart';

class FreedrawConfig {
  double size = 3.0;
  double thinning = 0.1;
  double smoothing = 0.5;
  double streamline = 0.5;
  double taperStart = 0.0;
  bool capStart = true;
  double taperEnd = 0.1;
  bool capEnd = true;
  bool simulatePressure = true;
  bool isComplete = false;
  Color color = Colors.green;
}
