import 'package:flutter/material.dart';

import 'page/board_widget.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BoardWidget(),
    );
  }
}
