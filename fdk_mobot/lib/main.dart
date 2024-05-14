import 'package:flutter/material.dart';
import 'package:fdk_mobot/controllers/robot_controller.dart';
import 'package:fdk_mobot/views/robot_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final RobotController controller = RobotController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Differential Steering Simulation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RobotView(controller: controller),
    );
  }
}
