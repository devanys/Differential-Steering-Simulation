import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RobotStatus {
  final double xDot;
  final double yDot;
  final double v;
  final double w;
  final double x;
  final double y;
  final double orientationPsi;

  RobotStatus({
    required this.xDot,
    required this.yDot,
    required this.v,
    required this.w,
    required this.x,
    required this.y,
    required this.orientationPsi,
  });
}

class RobotController extends ChangeNotifier {
  double currentX = 0.0;
  double currentY = 0.0;
  double leftSpeed = 0.0;
  double rightSpeed = 0.0;
  double leftRadius = 0.0;
  double rightRadius = 0.0;
  double bodyRadius = 0.0;
  double orientation = 0.0;
  List<Offset> route = [];
  final int gridSize = 22;

  late Timer _timer;
  static const double _timerInterval = 0.1;

  void setRobotPosition(double x, double y) {
    currentX = x;
    currentY = y;
    notifyListeners();
  }

  void setParameters(double leftSpeed, double rightSpeed, double leftRadius, double rightRadius, double bodyRadius, double orientation) {
    this.leftSpeed = leftSpeed;
    this.rightSpeed = rightSpeed;
    this.leftRadius = leftRadius;
    this.rightRadius = rightRadius;
    this.bodyRadius = bodyRadius;
    this.orientation = orientation;
    notifyListeners();
  }

  void startMovement() {
    _timer = Timer.periodic(Duration(milliseconds: (_timerInterval * 1000).toInt()), (timer) {
      _moveRobot();
    });
  }

  RobotStatus getRobotStatus() {
    double v = (leftSpeed + rightSpeed) / 2;
    
    double w = (rightSpeed - leftSpeed) / bodyRadius;

    double xDot = v * cos(orientation);
    double yDot = v * sin(orientation);

    return RobotStatus(
      xDot: xDot,
      yDot: yDot,
      v: v,
      w: w,
      x: currentX,
      y: currentY,
      orientationPsi: orientation,
    );
  }

void _moveRobot() {
  RobotStatus status = getRobotStatus();

  // Calculate curvature based on the ratio of left and right radii
  double curvature = (rightRadius - leftRadius) / (2 * bodyRadius);

  // Calculate angular velocity (w) based on curvature and linear velocity (v)
  double w = status.v * curvature;

  // Calculate the change in orientation
  double deltaOrientation = w * _timerInterval;

  // Update orientation
  orientation += deltaOrientation;

  // Calculate linear displacement
  double deltaX = status.v * cos(orientation) * _timerInterval;
  double deltaY = status.v * sin(orientation) * _timerInterval;

  // Update position
  double newX = currentX + deltaX;
  double newY = currentY + deltaY;

  // Check if the new position is within the grid boundaries
  if (newX < 0 || newX >= gridSize || newY < 0 || newY >= gridSize) {
    reset();
  } else {
    currentX = newX;
    currentY = newY;
    route.add(Offset(currentX, currentY));
    notifyListeners();
  }
}


  void reset() {
    currentX = 0.0;
    currentY = 0.0;
    leftSpeed = 0.0;
    rightSpeed = 0.0;
    leftRadius = 0.0;
    rightRadius = 0.0;
    bodyRadius = 0.0;
    orientation = 0.0;
    route.clear(); 
    notifyListeners(); 
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
