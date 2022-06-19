classdef IncrementalRobot
    properties (Constant)
        wheelRadius = (1/2) * (195/1000)
        wheelAxis = (1/2) * (381/1000)
    end
    properties (Dependent)
        velocity
        angularVelocity
        body
        leftWheel
        rightWheel
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
            robotBody = [
                100 , 227.5 , 227.5 , 100 , -200 , -227.5 , -227.5 , -200
                -190.5 , -50 , 50 , 190.5 , 190.5 , 163 , -163 , -190.5
            ] / 1000;
            robotBody = [robotBody; [1 1 1 1 1 1 1 1]];

            robotBody = obj.rotateZ(robotBody);
            robotBody = obj.translate(robotBody);
        end

        function robotLeftWheel = get.leftWheel(obj)
            robotLeftWheel = [
                97.5 97.5 -97.5 -97.5
                170.5 210.5 210.5 170.5
            ] / 1000;
            robotLeftWheel = [robotLeftWheel; [1 1 1 1]];

            robotLeftWheel = obj.rotateZ(robotLeftWheel);
            robotLeftWheel = obj.translate(robotLeftWheel);
        end

        function robotRightWheel = get.rightWheel(obj)
            robotRightWheel = [
                97.5 97.5 -97.5 -97.5
                -170.5 -210.5 -210.5 -170.5
            ] / 1000;
            robotRightWheel = [robotRightWheel; [1 1 1 1]];

            robotRightWheel = obj.rotateZ(robotRightWheel);
            robotRightWheel = obj.translate(robotRightWheel);
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

        function outputMatrix = translate(obj, inputMatrix)
            x = obj.position(1);
            y = obj.position(2);

            translationMatrix = [
                1 0 x
                0 1 y
                0 0 1
            ];

            outputMatrix = translationMatrix * inputMatrix;
        end

        function outputMatrix = rotateZ(obj, inputMatrix)
            theta = obj.position(3);

            rotationMatrix = [
                cos(theta) -sin(theta) 0
                sin(theta)  cos(theta) 0
                0           0          1
            ];

            outputMatrix = rotationMatrix * inputMatrix;
        end

        function obj = addPositionHistory(obj)
            obj.positionHistory = [obj.positionHistory, obj.position];
        end

    end
end