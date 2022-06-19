classdef Robot
    properties (Constant)
        wheelRadius = (1/2) * (195/1000)
        wheelAxis = (1/2) * (381/1000)
    end
    properties (Dependent)
        velocity
        angularVelocity
        inertialFrameVelocity
        body
    end
    properties
        position = [0; 0; 0]
        positionHistory = []
        leftWheelAngularVelocity = deg2rad(60)
        rightWheelAngularVelocity = deg2rad(90)
    end
    methods

        function obj = Robot(position)
            obj.position = position;
        end

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

        function inertialFrameVelocity = get.inertialFrameVelocity(obj)
            theta = obj.position(3);
            inertialFrameVelocity = [
                cos(theta) 0
                sin(theta) 0
                0          1
            ] * [obj.velocity; obj.angularVelocity];
        end

        function robotBody = get.body(obj)
            robotBody = RobotBody(obj);
        end

        function obj = move(obj, timeSample)
            obj.position = ( ...
                obj.position + ...
                obj.inertialFrameVelocity * timeSample ...
            );
        end

        function obj = addPositionHistory(obj)
            obj.positionHistory = [obj.positionHistory, obj.position];
        end

    end
end