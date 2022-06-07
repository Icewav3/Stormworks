function onTick()
    radar = {
        --on
        input.getBool(1);
        --distance
        input.getNumber(1);
        --azimuth
        input.getNumber(2);
        --elevation angle
        input.getNumber(3);
        --time detected
        input.getNumber(4);
    
        input.getBool(2);
        input.getNumber(5);
        input.getNumber(6);
        input.getNumber(7);
        input.getNumber(8);
    
        input.getBool(3);
        input.getNumber(9);
        input.getNumber(10);
        input.getNumber(11);
        input.getNumber(12);
    
        input.getBool(4);
        input.getNumber(13);
        input.getNumber(14);
        input.getNumber(15);
        input.getNumber(16);
    
        input.getBool(5);
        input.getNumber(17);
        input.getNumber(18);
        input.getNumber(19);
        input.getNumber(20);
    
        input.getBool(6);
        input.getNumber(21);
        input.getNumber(22);
        input.getNumber(23);
        input.getNumber(24);
    
        input.getBool(7);
        input.getNumber(25);
        input.getNumber(26);
        input.getNumber(27);
        input.getNumber(28);
    
        input.getBool(8);
        input.getNumber(29);
        input.getNumber(30);
        input.getNumber(31);
        input.getNumber(32) 
    }
    for x=1, (#radar), 4 do
        if radar[x] = true then
            for x=2, (#radar), 4 do
        end
    end
end