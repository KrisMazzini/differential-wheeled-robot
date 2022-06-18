clear; close all; clc;

robot = Robot;
robot = robot.addPositionHistory;

simTimeSampling = 0.25;
simMaxTime = 30;

for time = 0:simTimeSampling:simMaxTime
  
    robot = robot.move(simTimeSampling);
    robot = robot.addPositionHistory;
    robot.plotRobot(time);

end