--do not go below -9 or above 99
gearmin = -1
gearmax = 4
function onTick()
    up = input.getBool(3)
    down = input.getBool(4)
        if value == nil then
            value = 0
        end
        if value > gearmax then
            value = gearmax
        elseif value < gearmin then
            value = gearmin
        elseif up ~= upinput and up == true then
            value = value + 1
        elseif down ~= downinput and down == true then
            value = value -1
        else
        --neutral
        end
        if value ~= 0 then
            clutch = 1
        else
            clutch = 0
        end
        --gears
        reverse = false
        gear1 = false
        gear2 = false
        gear3 = false
        gear4 = false
        if value == -1 then
            reverse = true
        elseif value == 1 then
            gear1 = true
        elseif value == 2 then
            gear2 = true
        elseif value == 3 then
            gear3 = true
        elseif value == 4 then
            gear4 = true
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
    output.setNumber(3,clutch)
    output.setBool(4,reverse)
    output.setBool(5,gear1)
    output.setBool(6,gear2)
    output.setBool(7,gear3)
    output.setBool(8,gear4)
end
--Report bugs/suggestions to Icewave#0394 on discord or https://github.com/Icewav3/Stormworks/issues