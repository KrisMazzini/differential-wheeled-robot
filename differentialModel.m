clear; close all; clc;

initialPosition = [0; 0; 0];
goalPosition = [0; 10; deg2rad(-90)];

robot = Robot(initialPosition);
goal = Robot(goalPosition);

fig = figure;
fig.Position = [0, 0, 2000, 2000];

plotRobot(robot, goal);
pause;

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

    controller = CloseLoopControl(robot, goal);

    plotRobot(robot, goal);

end