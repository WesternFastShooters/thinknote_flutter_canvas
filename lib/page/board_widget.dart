import 'package:flutter/material.dart';
import 'package:flutter_application_2/component/drop_down_menu.dart';
import 'package:flutter_application_2/component/gesture_layer.dart';
import 'package:flutter_application_2/component/toolbar.dart';
import 'package:flutter_application_2/component/white_board_layer.dart';

class BoardWidget extends StatelessWidget {
  const BoardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // LassoLayer(),
          const WhiteBoardLayer(),
          GestureLayer(),
          const Positioned(
            top: 20,
            right: 20,
            child: ToolBar(),
          ),
          DropDownMenu()
        ],
      ),
    );
  }
}
