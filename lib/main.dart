// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_2/model/graphics_canvas.dart';
import 'package:get/get.dart';
import 'page/board_widget.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(GraphicsCanvas());

    return const GetMaterialApp(
      home: BoardWidget(),
    );
  }
}
