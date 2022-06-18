clear; close all; clc;

robot = IncrementalRobot;
robot = robot.addPositionHistory;
robot.plotRobot(0);

simTimeSampling = 0.25;
simMaxTime = 30;

for time = 0:simTimeSampling:simMaxTime
  
    robot = robot.move(simTimeSampling);
    robot = robot.addPositionHistory;
    robot.plotRobot(time);

end