-- Percision positioning system

function onTick()
    pitch_in = input.getNumber(1)
    roll_in = input.getNumber(2)
    compass = input.getNumber(3)

    

    output.setNumber(1,pitch_out)
    output.setNumber(2,roll_out)
end

-- Report bugs/suggestions to Icewave#0394 on Discord or https://github.com/Icewav3/Stormworks/issues