pid = {
    prev_err=prev_err or 0;
    p_out=p_out or 0;
    i_out=i_out or 0;
    d_out=d_out or 0
}
function pid:run(setpoint, current, p, i, d)
        if current > setpoint*0.1 + setpoint then
            pid.i_out = 0
        end
        err = setpoint - current
        pid.p_out = err * p
        pid.i_out = (err * i) + pid.i_out
        pid.d_out = (err - pid.prev_err) * d
        pid.prev_err = err
    	out = pid.p_out + pid.i_out + pid.d_out
    return out or 0
end

function onTick()
    steering = input.getNumber(1)
    compass = input.getNumber(2)
    threshold = input.getNumber(3)
    if steering <= -threshold or steering >= threshold then
        steer_out = steering
        target = compass
    else
        steer_out = pid:run((target-compass+0.5)%1-0.5, compass, 1, 0.01, 0.1) or 0
    end
    output.setNumber(1,steer_out)
end
--Report bugs/suggestions to Icewave#0394 on discord or https://github.com/Icewav3/Stormworks/issue