function pid(setpoint, current, p_gain, i_gain, d_gain)
    
    err = setpoint - current
    p_out = err * p_gain
    i_out = err * i_gain
    d_out = err * d_gain
    output = p_out + i_out + d_out
    previous_err = err
    return output
end