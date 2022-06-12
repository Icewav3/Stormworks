function onTick()
    radar = {}

    for i = 1, 8 do
      radar[i * 5 - 4] = input.getBool(i) or 0
      for j = 3, 0, -1 do
        radar[i * 5 - j] = input.getNumber(i * 4 - j) or 0
      end
    end
    compass = input.getNumber(4) or 0
    tiltFront = input.getNumber(8) or 0
    tiltLeft = input.getNumber(12) or 0
    tiltUp = input.getNumber(16) or 0
    gpsx = input.getNumber(20) or 0
    gpsy = input.getNumber(24) or 0
    alt = input.getNumber(28) or 0
    --constants
    r = (#radar) --array length
    for x=1, (r), 5 do 
        if radar[x] == true then --is something detected?
            distance = radar[x+1]
            --covert to radians
            az_ang = (math.pi*2*radar[x+2])
            elev_ang = (math.pi*2*radar[x+3])
            tiltRoll = math.atan(math.sin(tiltRoll))
            tiltUp = math.sin(tiltUp)
            compass = compass*math.pi*2
            --make inputs reliable
            HorizontalAngle = -( horizontalradar*math.cos(tiltLeft) - verticalradar*math.sin(tiltLeft) + compass)
            VerticalAngle =  ( horizontalradar*math.sin(tiltLeft)  + verticalradar*math.cos(tiltLeft)) + tiltFront
            --get relative position
            relative_map_x = distance*math.sin(az_ang)*math.cos(elev_ang)
            relative_altitude = distance*math.sin(elevation)
            relative_map_y = distance*math.cos(az_ang)*math.cos(elev_ang)
            --TODO
            target_x = gpsx + relative_map_x
            target_y = gpsy + relative_map_y
            target_z = alt + relative_altitude
        end
    end
    output.setBool(1, radar[1])
end