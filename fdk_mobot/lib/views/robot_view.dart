import 'package:flutter/material.dart';
import 'package:fdk_mobot/controllers/robot_controller.dart';

class RobotView extends StatefulWidget {
  final RobotController controller;

  const RobotView({Key? key, required this.controller}) : super(key: key);

  @override
  _RobotViewState createState() => _RobotViewState();
}

class _RobotViewState extends State<RobotView> {
  late TextEditingController _xController;
  late TextEditingController _yController;
  late TextEditingController _leftSpeedController;
  late TextEditingController _rightSpeedController;
  late TextEditingController _leftRadiusController;
  late TextEditingController _rightRadiusController;
  late TextEditingController _bodyRadiusController;
  late TextEditingController _orientationController;
  bool isMoving = false; // Variable to track movement state

  @override
  void initState() {
    super.initState();
    _xController = TextEditingController();
    _yController = TextEditingController();
    _leftSpeedController = TextEditingController();
    _rightSpeedController = TextEditingController();
    _leftRadiusController = TextEditingController();
    _rightRadiusController = TextEditingController();
    _bodyRadiusController = TextEditingController();
    _orientationController = TextEditingController();
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    _leftSpeedController.dispose();
    _rightSpeedController.dispose();
    _leftRadiusController.dispose();
    _rightRadiusController.dispose();
    _bodyRadiusController.dispose();
    _orientationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Differential Steering Simulation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Robot Position: (${widget.controller.currentX.toStringAsFixed(2)}, ${widget.controller.currentY.toStringAsFixed(2)})'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _xController,
                    decoration: InputDecoration(labelText: 'Position X'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _yController,
                    decoration: InputDecoration(labelText: 'Position Y'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _leftSpeedController,
                    decoration: InputDecoration(labelText: 'Left Speed (θL)'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _rightSpeedController,
                    decoration: InputDecoration(labelText: 'Right Speed (θR)'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _leftRadiusController,
                    decoration: InputDecoration(labelText: 'Left Radius'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _rightRadiusController,
                    decoration: InputDecoration(labelText: 'Right Radius'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _bodyRadiusController,
                    decoration: InputDecoration(labelText: 'Body Radius'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _orientationController,
                    decoration: InputDecoration(labelText: 'Orientation'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: isMoving ? null : () {
                    double x = double.tryParse(_xController.text) ?? 0.0;
                    double y = double.tryParse(_yController.text) ?? 0.0;
                    double leftSpeed = double.tryParse(_leftSpeedController.text) ?? 0.0;
                    double rightSpeed = double.tryParse(_rightSpeedController.text) ?? 0.0;
                    double leftRadius = double.tryParse(_leftRadiusController.text) ?? 0.0;
                    double rightRadius = double.tryParse(_rightRadiusController.text) ?? 0.0;
                    double bodyRadius = double.tryParse(_bodyRadiusController.text) ?? 0.0;
                    double orientation = double.tryParse(_orientationController.text) ?? 0.0;

                    widget.controller.setRobotPosition(x, y);
                    widget.controller.setParameters(leftSpeed, rightSpeed, leftRadius, rightRadius, bodyRadius, orientation);
                    widget.controller.startMovement();
                    setState(() {});
                    isMoving = true; // Set moving state to true
                  },
                  child: Text('Move'),
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.controller.reset();
                    setState(() {
                      isMoving = false; // Set moving state back to false
                    });
                  },
                  child: Text('Reset'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: AnimatedBuilder(
                animation: widget.controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: RobotPainter(
                      route: widget.controller.route,
                      isMoving: isMoving,
                      status: widget.controller.getRobotStatus(),
                    ),
                    size: Size.infinite,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RobotPainter extends CustomPainter {
  final List<Offset> route;
  final int gridSize = 22;
  final bool isMoving; // Variable to track movement state
  final RobotStatus status;

  RobotPainter({required this.route, required this.isMoving, required this.status});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw grid lines
    Paint gridPaint = Paint()
      ..color = Colors.grey[200]!
      ..strokeWidth = 1.0;
    double cellWidth = size.width / (gridSize - 1);
    double cellHeight = size.height / (gridSize - 1);
    for (int i = 0; i < gridSize; i++) {
      canvas.drawLine(Offset(i * cellWidth, 0), Offset(i * cellWidth, size.height), gridPaint);
      canvas.drawLine(Offset(0, i * cellHeight), Offset(size.width, i * cellHeight), gridPaint);

      // Draw x and y labels
      TextPainter xLabelPainter = TextPainter(
        text: TextSpan(text: '$i', style: TextStyle(color: Colors.black)),
        textDirection: TextDirection.ltr,
      )..layout();
      xLabelPainter.paint(canvas, Offset(i * cellWidth +   2, size.height - 15));

      TextPainter yLabelPainter = TextPainter(
        text: TextSpan(text: '${gridSize - i - 2}', style: TextStyle(color: Colors.black)),
        textDirection: TextDirection.ltr,
      )..layout();
      yLabelPainter.paint(canvas, Offset(2, i * cellHeight + 2));
    }

    // Draw route
    if (route.isNotEmpty) {
      Paint routePaint = Paint()
        ..color = Colors.green
        ..strokeWidth = 2.0;
      Path routePath = Path();
      for (int i = 0; i < route.length; i++) {
        double x = (route[i].dx + 0.5) * cellWidth;
        double y = size.height - (route[i].dy + 0.5) * cellHeight;
        if (i == 0) {
          routePath.moveTo(x, y);
        } else {
          routePath.lineTo(x, y);
        }
      }
      canvas.drawPath(routePath, routePaint);
    }

    // Draw robot as a dot
    if (route.isNotEmpty) {
      Paint robotPaint = Paint()
        ..color = isMoving ? Colors.red : Colors.blue // Change color when moving
        ..strokeWidth = 3.0;
      Offset robotPosition = Offset((route.last.dx + 0.5) * cellWidth, size.height - (route.last.dy + 0.5) * cellHeight);
      canvas.drawCircle(robotPosition, 5.0, robotPaint);

      // Draw status text near the dot
      TextPainter statusPainter = TextPainter(
        text: TextSpan(
          text: 'xDot: ${status.xDot.toStringAsFixed(2)}\n'
              'yDot: ${status.yDot.toStringAsFixed(2)}\n'
              'v: ${status.v.toStringAsFixed(2)}\n'
              'w: ${status.w.toStringAsFixed(2)}\n'
              'x: ${status.x.toStringAsFixed(2)}\n'
              'y: ${status.y.toStringAsFixed(2)}\n'
              'orientationPsi: ${status.orientationPsi.toStringAsFixed(2)}',
          style: TextStyle(color: Colors.black, fontSize: 12.0),
        ),
        textDirection: TextDirection.ltr,
      );
      statusPainter.layout();
      Offset statusPosition = Offset(robotPosition.dx + 10, robotPosition.dy + 10); // Adjust position as needed
      statusPainter.paint(canvas, statusPosition);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

