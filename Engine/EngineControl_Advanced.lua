--v 0.5
pid = {
    prev_err=prev_err or 0;
    p_out=p_out or 0;
    i_out=i_out or 0;
    d_out=d_out or 0
}
function pid:run(min_setpoint, setpoint, current, p, i, d)
    current = current or 0
    if setpoint > min_setpoint then
        if current > setpoint*0.1 + setpoint then
            pid.i_out = pid.i_out / 2
        end
        err = setpoint - current
        pid.p_out = err * p
        pid.i_out = (err * i) + pid.i_out
        pid.d_out = (err - pid.prev_err) * d
        pid.prev_err = err
    else
        pid.prev_err = 0
        pid.p_out = 0
        pid.i_out = 0 
        pid.d_out = 0
    end
    out = pid.p_out + pid.i_out + pid.d_out
    return out
end

function counter(desired,current,sensitivity,min,max)
    if counter_out == nil then
        counter_out = 0
    end
    if counter_out > max then
        counter_out = max
    elseif current < desired then
        counter_out = counter_out + sensitivity
    elseif counter_out < min then
        counter_out = min
    elseif current > desired then
        counter_out = counter_out - sensitivity
    end
    return counter_out
end

--constants
airOut = 1
minRPS = 2.1
--get variables
function onTick()
    CurrentAir = input.getNumber(1)
    CurrentFuel = input.getNumber(2)
    AFR = CurrentAir/CurrentFuel
    Temp = input.getNumber(3)
    DesiredRPS = input.getNumber(4)
    CurrentRPS = input.getNumber(5)
    Charge = input.getNumber(6)

    -- Emergency power generator
    if (Charge < 0.25) and (Charge > 0.1) then
        GeneratorRPS = 10
    else
        GeneratorRPS = 0
    end

    -- Engine throttler
    TargetRPS = math.max(GeneratorRPS,DesiredRPS)
    if TargetRPS < minRPS then
        throttleout = 0
        starter = false
    else 
        if (CurrentRPS < minRPS) or (CurrentRPS == nil) then
            starter = true
        else
            starter = false 
        end
        throttleout = pid:run(minRPS, TargetRPS, CurrentRPS, 0.2, 0.0001, 0.1)
        if Temp > 100 then
            throttleout = 0
        elseif throttleout > 0.5 then
            throttleout = 0.5
        else
        end
        --AFR optimizier
        airOut = counter(14,AFR,0.005,0,1)
        
        --alternator
        if Charge > 0.9 then
            alternator = 0
        else
            alternator = 1
        end
    end

    --outputs
    output.setNumber(1,Temp)
    output.setNumber(2,CurrentRPS)
    output.setNumber(3,Charge)
    output.setNumber(4,AFR)
    output.setBool(5,starter)
    output.setNumber(6,airOut)
    output.setNumber(7,throttleout)
    output.setNumber(8,alternator)
end
--Report bugs/suggestions to Icewave#0394 on discord or https://github.com/Icewav3/Stormworks/issues