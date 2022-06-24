classdef PotentialField
    properties (Constant)
        kAtt = 1/4;
        kRep = 1/40;
    end
    properties (Dependent)
        err
        rho
        fAtt
        fRep
        fTot
    end
    properties
        current
        goal
        obstacles
        collision = false
    end
    methods
        
        function obj = PotentialField(current, goal, obstacles)
            obj.current = current;
            obj.goal = goal;
            obj.obstacles = obstacles;
        end

        function error = get.err(obj)
            error = obj.goal.position - obj.current.position;
        end

        function rho = get.rho(obj)
            dx = obj.err(1);
            dy = obj.err(2);

            rho = sqrt(dx^2 + dy^2);
        end

        function fAtt = get.fAtt(obj)
            fAtt = obj.kAtt * obj.err(1:2);
        end

        function fRep = get.fRep(obj)
            fRep = [0;0];
            for ind = 1:length(obj.obstacles)
                fRep = fRep + calculateObstacleRep(obj, obj.obstacles(ind));
            end

        end

        function fTot = get.fTot(obj)
            fTot = obj.fAtt + obj.fRep;
        end

        function obsFRep = calculateObstacleRep(obj, obstacle)
            dx = obstacle.position(1,:) - obj.current.position(1);
            dy = obstacle.position(2,:) - obj.current.position(2);
            distance = sqrt(dx.^2 + dy.^2);

            underInfluenceZone = find(distance <= obj.current.influenceZone);

            if ~isempty(underInfluenceZone)
                
                Z = ( ...
                    1./distance(underInfluenceZone) .* ...
                    (1/obj.current.influenceZone - 1./distance(underInfluenceZone)) ...
                );

                obsFRep = obj.kRep * [
                    sum(Z .* (obstacle.position(1, underInfluenceZone) - obj.current.position(1)))
                    sum(Z .* (obstacle.position(2, underInfluenceZone) - obj.current.position(2)))
                ];

                if min(distance(underInfluenceZone)) <= obj.current.collisionZone
                    obsFRep = [Inf, Inf];
                end

            else
                obsFRep = [0;0];
            end
        end

    end
end