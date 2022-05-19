function onTick()
    vertical = input.getNumber(1)
    yaw = input.getNumber(2)
    if yaw ~= 0 then
        top_rotor = vertical
        btm_rotor = vertical*-1
    end
    if vertical ~= 0 then
        top_rotor = vertical
        btm_rotor = vertical
    end
    output.setNumber(1,top_rotor)
    output.setNumber(2,btm_rotor)
end
--Report bugs/suggestions to Icewave#0394 on discord or https://github.com/Icewav3/Stormworks/issues