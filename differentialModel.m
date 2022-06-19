clear; close all; clc;

initialPosition = [0; 0; 0];

robot = Robot(initialPosition);
robot = robot.addPositionHistory;

plotRobot(robot, 0);

simTimeSampling = 0.25;
simMaxTime = 30;

for time = 0:simTimeSampling:simMaxTime
  
    robot = robot.move(simTimeSampling);
    robot = robot.addPositionHistory;
    plotRobot(robot, time);

end