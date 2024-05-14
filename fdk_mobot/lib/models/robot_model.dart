class RobotModel {
  double radiusLeftWheel;
  double radiusRightWheel;
  double radiusBody;
  double positionX;
  double positionY;
  double orientation;
  double speedLeftWheel;
  double speedRightWheel;

  RobotModel({
    required this.radiusLeftWheel,
    required this.radiusRightWheel,
    required this.radiusBody,
    required this.positionX,
    required this.positionY,
    required this.orientation,
    required this.speedLeftWheel,
    required this.speedRightWheel,
  });

  // Add methods to control robot movement, reset, etc.
}
