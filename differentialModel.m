clear; close all; clc;

timeElapsed = 0;
maxSimTime = 30;

initialPosition = [0; 0; 0];
goalPosition = [10; -15; deg2rad(30)];

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

while (controller.rho > maxDistanceError) && timeElapsed < maxSimTime

    tic

    if (controller.fTot(1) == Inf || controller.fTot(2) == Inf)
        title('A collision occured')
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

    timeElapsed = timeElapsed + toc;

end

if controller.rho <= maxDistanceError
    title('Goal completed :)')
end

if timeElapsed >= maxSimTime
    title('Max simulation time reached. Goal not completed!')
end