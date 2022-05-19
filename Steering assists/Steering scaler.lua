function clamp(input,min,max)
    if input < min then
        value = min
    elseif input > max then
        value = max
    else
    end
    return value
end
function onTick()
    steering = input.getNumber(1)
    speed = input.getNumber(2)
    min = input.getNumber(3)
    max = input.getNumber(4)
    limit = input.getNumber(5)
    if steering ~= 0 then
        if speed < limit then 
            adjusted_steering = steering
        else
            adjusted_steering=clamp(steering,min,max)
        end
    end
    output.setNumber(1,adjusted_steering)
end
--Report bugs/suggestions to Icewave#0394 on discord or https://github.com/Icewav3/Stormworks/issues