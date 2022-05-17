function onTick()
    up = input.getBool(3)
    down = input.getBool(4)
        if value == nil then
            value = 0
        end
        if value > 99 then
            value = 99
        elseif value < -9 then
            value = -9
        elseif up ~= upinput and up == true then
            value = value + 1
        elseif down ~= downinput and down == true then
            value = value -1
        else
        end
        upinput = up
        downinput = down
        ones = math.abs(value)%10
        if value < 0 then
            tens = -1
        else
            tens = (value-ones)/10
        end
    output.setNumber(1,tens)
    output.setNumber(2,ones)
    output.setNumber(3,value)
end
--Report bugs/suggestions to Icewave#0394 on discord or https://github.com/Icewav3/Stormworks/issues