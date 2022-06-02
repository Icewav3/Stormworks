pid = {
    prev_err=prev_err or 0;
    p_out=p_out or 0;
    i_out=i_out or 0;
    d_out=d_out or 0
}
function pid:run(setpoint, current, p, i, d)
    err = setpoint - current
    pid.p_out = err * p
    pid.i_out = (err * i) + pid.i_out
    pid.d_out = (err - pid.prev_err) * d
    pid.prev_err = err
    out = pid.p_out + pid.i_out + pid.d_out
    return out
end
function onTick()
    Setpoint = input.getNumber(1)
    Current = input.getNumber(2)
    throttle = pid:run(Setpoint, Current, 0.2, 0.0001, 0.1)
    output.setNumber(1,throttle)
end