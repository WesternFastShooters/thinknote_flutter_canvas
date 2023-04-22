// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_2/model/white_board_manager.dart';
import 'package:get/get.dart';
import 'page/board_widget.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(WhiteBoardManager());

    return GetMaterialApp(
      home: BoardWidget(),
    );
  }
}
