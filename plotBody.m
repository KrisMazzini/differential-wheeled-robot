function plotBody(robot, color)

    fill(robot.body.center(1,:), robot.body.center(2,:), color)
            
    hold on;

    fill( ...
        robot.body.leftWheel(1,:), ...
        robot.body.leftWheel(2,:), ...
        color ...
    );

    fill( ...
        robot.body.rightWheel(1,:), ...
        robot.body.rightWheel(2,:), ...
        color ...
    );

end