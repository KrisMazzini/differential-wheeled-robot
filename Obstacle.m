classdef Obstacle
    properties
        meanPointFactor
        radius
        dispersion
        position
    end
    methods
        function obj = Obstacle(robot, goal)
            meanPoint = (robot.position(1:2) + goal.position(1:2)) / 2;
            
            obj.meanPointFactor = norm(meanPoint) / 2;
            obj.radius = 0.15 * obj.meanPointFactor;
            obj.dispersion = 1 * obj.meanPointFactor;
            
            angle = 0:2:360;

            obj.position = [
                (meanPoint(1) + obj.dispersion * randn) + obj.radius * cosd(angle)
                (meanPoint(2) + obj.dispersion * randn) + obj.radius * sind(angle)
            ];
        end
    end
end