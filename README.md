![image](https://github.com/devanys/Differential-Steering-Simulation/assets/145944367/ccef00ef-a66b-445c-b784-ac1e7aceec83)
# Differential Steering Simulation

## Overview

This Flutter application simulates the movement of a robot using differential steering. The robot's parameters such as position, wheel speeds, radii, body radius, and orientation can be set by the user. The simulation visualizes the robot's movement on a grid and provides real-time updates of its status parameters.

## Installation

Before running the application, ensure you have Flutter installed on your machine. Follow these steps to get started:

1. **Clone the repository:**
    ```bash
    git clone https://github.com/devanys/Differential-Steering-Simulation.git
    cd Differential-Steering-Simulation
    ```

2. **Install dependencies:**
    ```bash
    flutter pub get
    ```

## Usage

1. **Set Parameters:** Input the robot's initial position (X and Y), left and right wheel speeds, left and right radii, body radius, and orientation using the provided text fields.

2. **Start Movement:** Click the "Move" button to begin the simulation.

3. **Observe:** Monitor the robot's movement on the grid and observe real-time updates of its status parameters.

4. **Reset:** Press the "Reset" button to stop the simulation and reset the robot's parameters.

## Code Overview

### RobotController

The `RobotController` class manages the robot's parameters and movement. It computes the robot's velocity and angular velocity based on the wheel speeds and radii, updates its position and orientation, and handles the simulation's timing.

### RobotView

The `RobotView` widget serves as the main interface for the simulation. It includes input fields for the robot's parameters, buttons to control the simulation, and a `CustomPaint` widget to visualize the robot's path and status.

### RobotPainter

The `RobotPainter` class extends `CustomPainter` to draw the robot's path on the grid. It dynamically updates the robot's position and status based on the user-defined parameters.

## Contributing

Contributions are welcome! If you have any ideas for improvements or encounter any issues, please feel free to open an issue or submit a pull request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/YourFeature`)
3. Commit your changes (`git commit -m 'Add some feature'`)
4. Push to the branch (`git push origin feature/YourFeature`)
5. Open a pull request

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgements

Special thanks to all the contributors and the Flutter community for their support and resources.
