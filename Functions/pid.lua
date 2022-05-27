function pid(setpoint, current, p, i, d)
    err = setpoint - current
    p_out = err * p
    i_out = err * i
    d_out = err * d
    output = p_out + i_out + d_out
    return output
end