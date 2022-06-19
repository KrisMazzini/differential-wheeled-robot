classdef CloseLoopControl
    properties (Constant)
        kRho = 2/11
        kAlpha = 345/823
        kBeta = -2/11
    end
    properties (Dependent)
        err
        rho
        gamma
        alpha
        beta
    end
    properties
        currentPosition
        goalPosition
        driveBackwards = false;
    end
    methods
        
        function obj = CloseLoopControl(current, goal)
            obj.currentPosition = current.position;
            obj.goalPosition = goal.position;
        end

        function error = get.err(obj)
            error = obj.goalPosition - obj.currentPosition;
        end

        function rho = get.rho(obj)
            dx = obj.err(1);
            dy = obj.err(2);

            rho = sqrt(dx^2 + dy^2);
        end

        function gamma = get.gamma(obj)
            dx = obj.err(1);
            dy = obj.err(2);

            gamma = adjustAngle(atan2(dy, dx));
        end

        function alpha = get.alpha(obj)
            currTheta = obj.currentPosition(3);
            
            alpha = adjustAngle(obj.gamma - currTheta);
            alpha = invertAngle(obj, alpha);
        end

        function beta = get.beta(obj)
            goalTheta = obj.goalPosition(3);

            beta = adjustAngle(goalTheta - obj.gamma);
            beta = invertAngle(obj, beta);
        end

        function angle = invertAngle(obj, angle)
            if obj.driveBackwards
                angle = adjustAngle(angle + pi);
            end
        end

        function obj = shouldDriveBackwards(obj, angle)
            obj.driveBackwards = abs(angle) > pi/2;
        end

    end
end