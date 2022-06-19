classdef IncrementalRobot
    properties (Constant)
        wheelRadius = (1/2) * (195/1000)
        wheelAxis = (1/2) * (381/1000)
    end
    properties (Dependent)
        velocity
        angularVelocity
        body
    end
    properties
        position = [0; 0; 0]
        positionHistory = []
        leftWheelAngularVelocity = deg2rad(60)
        rightWheelAngularVelocity = deg2rad(90)
    end
    methods

        function velocity = get.velocity(obj)
            velocity = obj.wheelRadius/2 * ( ...
                obj.rightWheelAngularVelocity + ...
                obj.leftWheelAngularVelocity ...
            );
        end

        function angularVelocity = get.angularVelocity(obj)
            angularVelocity = obj.wheelRadius/obj.wheelAxis * ( ...
                obj.rightWheelAngularVelocity - ...
                obj.leftWheelAngularVelocity ...
            );
        end

        function robotBody = get.body(obj)
            robotBody = RobotBody(obj);
        end

        function obj = move(obj, timeSample)
            coveredDistance = obj.velocity * timeSample;
            coveredAngle = obj.angularVelocity * timeSample;

            theta = obj.position(3);

            positionVariation = [
                coveredDistance * cos(theta + coveredAngle/2)
                coveredDistance * sin(theta + coveredAngle/2)
                coveredAngle
            ];
            
            obj.position = obj.position + positionVariation;
        end

        function obj = addPositionHistory(obj)
            obj.positionHistory = [obj.positionHistory, obj.position];
        end

    end
end