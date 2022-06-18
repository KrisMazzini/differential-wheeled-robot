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

        function inertialFrameVelocity = get.inertialFrameVelocity(obj)
            theta = obj.position(3);
            inertialFrameVelocity = [
                cos(theta) 0
                sin(theta) 0
                0          1
            ] * [obj.velocity; obj.angularVelocity];
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
            obj.position = ( ...
                obj.position + ...
                obj.inertialFrameVelocity * timeSample ...
            );
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

        function plotRobot(obj, time)
            x = obj.position(1);
            y = obj.position(2);
            theta = obj.position(3);

            fill(obj.body(1,:), obj.body(2,:), 'y')
            
            hold on;

            fill(obj.leftWheel(1,:), obj.leftWheel(2,:), 'y')
            fill(obj.rightWheel(1,:), obj.rightWheel(2,:), 'y')

            plot( ...
                obj.positionHistory(1,:), ...
                obj.positionHistory(2,:), ...
                'b', 'lineWidth', 2 ...
            );

            plot( ...
                x, y, ...
                'or', 'linewidth', 2, ...
                'markersize', 15 ...
            );

            plot( ...
                [x, x + 0.1*cos(theta)], ...
                [y, y + 0.1*sin(theta)], ...
                'r', 'linewidth', 2 ...
            );

            plot( ...
                [x, x + obj.wheelAxis/2*cos(theta + pi/2)], ...
                [y, y + obj.wheelAxis/2*sin(theta + pi/2)], ...
                'k', 'linewidth', 2 ...
            );

            plot( ...
                [x, x + obj.wheelAxis/2*cos(theta - pi/2)], ...
                [y, y + obj.wheelAxis/2*sin(theta - pi/2)], ...
                'k', 'linewidth', 2 ...
            );

            hold off;
            axis equal;
            xlabel('x [m]');
            ylabel('y [m]');
            title(['Time: t = ' num2str(time)])
            grid on;
            drawnow
        end

    end
end