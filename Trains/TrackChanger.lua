-- Deprecated

function onTick()
    freq = 440
    Left = input.getBool(1)
    Right = input.getBool(2)
    if (Left ~= last_left) then
        left_queued = not left_queued
    end
    if (Right ~= last_right) then
        right_queued = not right_queued
    end
    last_right = Right
    last_left = Left
    --
    output.setBool(1,track_toggle)
    output.setBool(3,left_queued)
    output.setBool(4,right_queued)
end


--Report bugs/suggestions to Icewave#0394 on discord or https://github.com/Icewav3/Stormworks/issues