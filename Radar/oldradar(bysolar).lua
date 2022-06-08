function onTick()

    tgt = gB(1)
    dist = gN(1)
    tiltpitch = gN(2)*pi2
    radarh = gN(3)*pi2
    radarv = gN(4)*pi2
    tiltside = gN(5)*pi2
    tiltup = gN(6)*pi2
    compass = gN(7)*pi2
    gpsX = gN(8)
    gpsY = gN(9)
    gpsZ = gN(10)
    
    
    if dist == 0 then return end
    
    roll = math.atan(tiltside,tiltup)
    
    --note: the function below corrects the radar's X and Y angles to the global X and Y. As the radar (and the vehicle it is mounted on) yaws, rolls, and pitches, its elevation angles change. In order to correct this, the compass and pitch are added.
    tx = (((radarh*(cos(roll)))-(radarv*(sin(roll))))+compass)*-1
    ty =  ((radarh*(sin(roll)))+(radarv*(cos(roll))))+tiltpitch
    
    -- estimates target local X,Y and altitude relative to the radar, and adds to GPS to get real-time values
    targetX, targetY, targetZ = relativeXYZ(tx,ty,dist)
    targetdist = distance(gpsX,gpsY,gpsZ,targetX,targetY,targetZ)
    
    sN(1,targetX)
    sN(2,targetY)
    sN(3,targetZ)
    sN(4,targetdist)
    
    end
    
    --distance formula
    function distance(currentx,currenty,currentz,targetx,targety,targetz)
    local tempX = targetx - currentx
    local tempY = targety - currenty
    local tempZ = targetz - currentz
    return sqrt((sqrt(tempX^2+tempY^2))^2+tempZ^2)
    end
    
    --XYZ calculation
    function relativeXYZ(yawangle,pitchangle,distance)
        local alt = (sin(pitchangle)*distance)+gpsZ
        local relativeXY = (cos(pitchangle)*distance)
        local relativeX = (sin(yawangle)*relativeXY)+gpsX
        local relativeY = (cos(yawangle)*relativeXY)+gpsY
    return relativeX,relativeY,alt 
    end