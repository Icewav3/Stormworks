function counter(desired,current,sensitivity)
    if counter_out == nil then
        counter_out = current
    end
    if counter_out < desired then
        counter_out = counter_out + sensitivity
    else
        counter_out = counter_out - sensitivity
    end
    return counter_out
end