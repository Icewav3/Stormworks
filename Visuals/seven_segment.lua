function onTick()
    up = input.getBool(3)
    down = input.getBool(4)
        if value == nil then
            value = 0
        end
        --TODO fix it going to -9
        if up ~= upinput and up == true then
            value = value + 1
        elseif down ~= downinput and down == true then
            value = value -1
        else
        end
        upinput = up
        downinput = down
        ones = value%10
        tens = (value-ones)/10
    output.setNumber(1,tens)
    output.setNumber(2,ones)
    output.setNumber(3,value)
end
--Report bugs to Icewave#0394