function onTick()
    vertical = input.getNumber(1)
    yaw = input.getNumber(2)
    btm_rotor = (vertical + (yaw*-1))/2
    top_rotor = (vertical + yaw)/2
    output.setNumber(1,top_rotor)
    output.setNumber(2,btm_rotor)
end
--Report bugs/suggestions to Icewave#0394 on discord or https://github.com/Icewav3/Stormworks/issues