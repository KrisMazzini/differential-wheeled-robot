clear; close all; clc;

initialPosition = [0; 0; 0];
goalPosition = [-5; -8; deg2rad(30)];

robot = Robot(initialPosition);
goal = Robot(goalPosition);

quantityOfObstacles = 5;
for ind = 1:quantityOfObstacles
    obstacles(ind) = Obstacle(robot, goal);
end

robot = robot.getInfluenceZone(obstacles(1));
goal = goal.getInfluenceZone(obstacles(1));

fig = figure;
fig.Position = [0, 0, 1000, 1000];

plotRobot(robot, goal, obstacles);
title('Press "space" to begin.')
pause;

simTimeSampling = 0.2;

controller = PotentialField(robot, goal, obstacles);

maxDistanceError = 0.01;

while controller.rho > maxDistanceError

    if (controller.fTot(1) == Inf || controller.fTot(2) == Inf)
        disp('A collision occured')
        break
    end

    velocity = norm(controller.fTot, 2);

    angularVelocity = adjustAngle( ...
        atan2(controller.fTot(2), controller.fTot(1)) - ...
        robot.position(3) ...
    );

    robot = robot.adjustWheels(velocity, angularVelocity);
    robot = robot.move(simTimeSampling);

    controller = PotentialField(robot, goal, obstacles);

    plotRobot(robot, goal, obstacles);

end

title('Goal completed :)')