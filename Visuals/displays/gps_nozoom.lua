--functions
function isPointInRectangle(x, y, rectX, rectY, rectW, rectH)
    return x > rectX and y > rectY and x < rectX+rectW and y < rectY+rectH
end
waypoints={}
function onTick()
    veh_x = input.getNumber(1) or 0
    veh_y = input.getNumber(2) or 0
    inputX = input.getNumber(3)
    inputY = input.getNumber(4)
    inputX2 = input.getNumber(5)
    inputY2 = input.getNumber(6)
    isPressed = input.getBool(1)
    isPressed2 = input.getBool(2)
    z = input.getNumber(8) or 0
    Zoom = input.getNumber(7) or 5
    output.setBool(1,translate)
    output.setNumber(3,wp)
    output.setNumber(4,#waypoints)
end

function onDraw()
    s_w = screen.getWidth()
    s_h = screen.getHeight()
    Uiscale = 1/16
    x_offset = x_offset or 0
    y_offset = y_offset or 0
    x = veh_x + x_offset
    y = veh_y + y_offset
    screen.drawMap(x, y, zoom)
    north = isPressed and isPointInRectangle(inputX, inputY, 0, 0, s_w, s_h*Uiscale)
    west = isPressed and isPointInRectangle(inputX, inputY, 0, 0, s_w*Uiscale, s_h)
    south = isPressed and isPointInRectangle(inputX, inputY, 0, s_h-(Uiscale*s_h), s_w, s_h*Uiscale)
    east = isPressed and isPointInRectangle(inputX, inputY, s_w-(Uiscale*s_w), 0, s_w*Uiscale, s_h)
    translate = north or west or south or east
    --translate cam
    if north == true then
        y_offset = y_offset + 1
    elseif south == true then 
        y_offset = y_offset - 1
    elseif east == true then
        x_offset = x_offset + 1
    elseif west == true then
        x_offset = x_offset - 1
    else end
    --reset cam
    if isPressed and isPressed2 then
        x_offset = 0
        y_offset = 0
        wp = nil
        waypoints={nil}
    end
    --set WP
    if isPressed and not translate and not lastpress then
        wp = wp or -1
        wp = wp + 2
        for i = wp, wp+1, 2 do
            waypoints[i] = inputX
            waypoints[i+1] = inputY
        end
    end
    lastpress = isPressed
    --draw wp
    if wp ~= nil then
        for n = 1, #waypoints, 2 do
            screen.setColor(255,0,0)
            screen.drawCircleF(waypoints[n],waypoints[n+1],3)
            screen.setColor(255,255,255)
        end
    end
    
    
    
    
    --[[screen.drawRectF(0, 0, s_w, s_h*Uiscale)
    screen.drawRectF(0, 0, s_w*Uiscale, s_h)
    screen.drawRectF(s_w-(Uiscale*s_w), 0, s_w*Uiscale, s_h)
    screen.setColor(255, 0, 0)
    screen.drawRectF(0, s_h-(Uiscale*s_h), s_w, s_h*Uiscale)]]--
end