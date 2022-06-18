--do not go below -9 or above 99
gearmin = -3
gearmax = 9
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
        if value == -1 then
            reverse = true
            gear6_5 = false
            gear3_2 = false
            gear9_5 = false
            gear2_1 = false
        elseif value == -2 then
            reverse = true
            gear6_5 = true
            gear3_2 = false
            gear9_5 = false
            gear2_1 = false
        elseif value == -3 then
            reverse = true
            gear6_5 = false
            gear3_2 = true
            gear9_5 = false
            gear2_1 = false
        elseif value == 9 then
            reverse = false
            gear6_5 = true
            gear3_2 = false
            gear9_5 = false
            gear2_1 = false
        elseif value == 8 then
            reverse = false
            gear6_5 = false
            gear3_2 = true
            gear9_5 = false
            gear2_1 = false
        elseif value == 7 then
            reverse = false
            gear6_5 = false
            gear3_2 = false
            gear9_5 = true
            gear2_1 = false
        elseif value == 6 then
            reverse = false
            gear6_5 = false
            gear3_2 = false
            gear9_5 = false
            gear2_1 = true
        elseif value == 5 then
            reverse = false
            gear6_5 = true
            gear3_2 = false
            gear9_5 = false
            gear2_1 = true
        elseif value == 4 then
            reverse = false
            gear6_5 = false
            gear3_2 = true
            gear9_5 = false
            gear2_1 = true
        elseif value == 3 then
            reverse = false
            gear6_5 = false
            gear3_2 = false
            gear9_5 = true
            gear2_1 = true
        elseif value == 2 then
            reverse = false
            gear6_5 = true
            gear3_2 = false
            gear9_5 = true
            gear2_1 = true
        elseif value == 1 then
            reverse = false
            gear6_5 = true
            gear3_2 = true
            gear9_5 = true
            gear2_1 = true
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