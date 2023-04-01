// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_2/modal/eraser_logic.dart';
import 'package:flutter_application_2/modal/freedraw_logic.dart';
import 'package:flutter_application_2/modal/lasso_logic.dart';
import 'package:flutter_application_2/modal/transform_logic.dart';
import 'package:flutter_application_2/modal/white_board_base.dart';
import 'package:get/get.dart';
import 'page/board_widget.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TransformLogic());
    Get.put(FreeDrawLogic());
    Get.put(EraserLogic());
    Get.put(LassoLogic());
    Get.put(WhiteBoardBase());


    return GetMaterialApp(
      home: BoardWidget(),
    );
  }
}
