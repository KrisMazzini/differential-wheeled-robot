clear; close all; clc;

initialPosition = [0; 0; 0];
goalPosition = [0; 4; deg2rad(180)];

robot = Robot(initialPosition);
goal = Robot(goalPosition);

robot = robot.addPositionHistory;
goal = goal.addPositionHistory;

plotRobot(robot, 0);

simTimeSampling = 0.2;

controller = CloseLoopControl(robot, goal);

maxDistanceError = 0.01;
maxAngleError = deg2rad(0.1);

while ( ...
    (controller.rho > maxDistanceError) || ...
    (abs(controller.alpha) > maxAngleError) || ...
    (abs(controller.beta) > maxAngleError) ...
)
    velocity = controller.kRho * controller.rho;
    angularVelocity = ( ...
        controller.kAlpha * controller.alpha + ...
        controller.kBeta * controller.beta ...
    );

    robot = robot.adjustWheels(velocity, angularVelocity);
    robot = robot.move(simTimeSampling);
    robot = robot.addPositionHistory;

    controller = CloseLoopControl(robot, goal);

    plotRobot(robot, 0);

end