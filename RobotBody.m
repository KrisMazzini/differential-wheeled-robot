classdef RobotBody
    properties (Dependent)
        center
        leftWheel
        rightWheel
    end
    properties
        position
    end
    methods
        function obj = RobotBody(robot)
            obj.position = robot.position;
        end

        function robotCenter = get.center(obj)
            robotCenter = [
                100 , 227.5 , 227.5 , 100 , -200 , -227.5 , -227.5 , -200
                -190.5 , -50 , 50 , 190.5 , 190.5 , 163 , -163 , -190.5
            ] / 1000;
            robotCenter = [robotCenter; [1 1 1 1 1 1 1 1]];

            robotCenter = obj.rotateZ(robotCenter);
            robotCenter = obj.translate(robotCenter);
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
    end
end