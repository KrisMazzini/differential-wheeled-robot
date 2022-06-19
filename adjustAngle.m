function newAngle = adjustAngle(angle)
    newAngle = mod(angle, 2*pi);

    if newAngle > pi
        newAngle = angle - 2*pi;
    end
    
end