clear; close all; clc;

initialPosition = [0; 0; 0];
goalPosition = [-5; -8; deg2rad(30)];

robot = Robot(initialPosition);
goal = Robot(goalPosition);

fig = figure;
fig.Position = [0, 0, 1000, 1000];

plotRobot(robot, goal);
title('Press "space" to begin.')
pause;

simTimeSampling = 0.2;

controller = CloseLoopControl(robot, goal);

maxDistanceError = 0.01;
maxAngleError = deg2rad(0.01);

while ( ...
    (controller.rho > maxDistanceError) || ...
    (abs(controller.err(3)) > maxAngleError) ...
)

    velocity = controller.kRho * controller.rho;

    controller = controller.shouldDriveBackwards(controller.alpha);

    if (controller.driveBackwards)
        velocity = -velocity;
    end

    angularVelocity = ( ...
        controller.kAlpha * controller.alpha + ...
        controller.kBeta * controller.beta ...
    );

    robot = robot.adjustWheels(velocity, angularVelocity);
    robot = robot.move(simTimeSampling);

    controller = CloseLoopControl(robot, goal);

    plotRobot(robot, goal);

end

title('Goal completed :)')