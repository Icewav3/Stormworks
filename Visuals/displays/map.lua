--functions
function isPointInRectangle(x, y, rectX, rectY, rectW, rectH)
    return x > rectX and y > rectY and x < rectX+rectW and y < rectY+rectH
end
waypoints={}
r=255
g=0
b=0
function onTick()
    veh_x = input.getNumber(1) or 0
    veh_y = input.getNumber(2) or 0
    inputX = input.getNumber(3)
    inputY = input.getNumber(4)
    compass = input.getNumber(5)
    alt = input.getNumber(6)
    isPressed = input.getBool(1)
    isPressed2 = input.getBool(2)
    Zoom = input.getNumber(7) or 1
    wp_num = 2*input.getNumber(8) or 0
    if #waypoints > 0 then
        for n = wp_num, wp_num+2, 1 do
            if n%2 == 1 then
                x=waypoints[n]
            else
                y=waypoints[n]
            end
        end
    else
        x=0
        y=0
    end
    output.setNumber(1,x)
    output.setNumber(2,y)
end

function onDraw()
    s_w = screen.getWidth()
    s_h = screen.getHeight()
    Uiscale = 1/16
    x_offset = x_offset or 0
    y_offset = y_offset or 0
    x = veh_x + x_offset
    y = veh_y + y_offset
    north = isPressed and isPointInRectangle(inputX, inputY, 0, 0, s_w, s_h*Uiscale)
    west = isPressed and isPointInRectangle(inputX, inputY, 0, 0, s_w*Uiscale, s_h)
    south = isPressed and isPointInRectangle(inputX, inputY, 0, s_h-(Uiscale*s_h), s_w, s_h*Uiscale)
    east = isPressed and isPointInRectangle(inputX, inputY, s_w-(Uiscale*s_w), 0, s_w*Uiscale, s_h)
    translate = north or west or south or east
    --translate cam
    if north == true then
        y_offset = y_offset + 1*Zoom+0.1 --funny fix
    elseif south == true then 
        y_offset = y_offset - 1*Zoom-0.1
    elseif east == true then
        x_offset = x_offset + 1*Zoom+0.1
    elseif west == true then
        x_offset = x_offset - 1*Zoom-0.1
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
            waypoints[i], waypoints[i+1] = map.screenToMap(x, y, Zoom, s_w, s_h, inputX, inputY)
        end
    end
    lastpress = isPressed
    --draw map
    screen.drawMap(x, y, Zoom)
    screen.setColor(r,g,b,75)
    veh_x_s, veh_y_s = map.mapToScreen(x, y, Zoom, s_w, s_h, veh_x, veh_y)
    screen.drawCircleF(veh_x_s,veh_y_s,3) --you
    --draw wp
    if wp ~= nil then
        for n = 1, #waypoints, 2 do
            p_x, p_y = map.mapToScreen(x, y, Zoom, s_w, s_h, waypoints[n], waypoints[n+1])
            --draw path
            if n<=1 then
                screen.drawLine(veh_x_s, veh_y_s, p_x, p_y)
            else
                screen.drawLine(p_x, p_y, last_px, last_py)
            end
            last_px = p_x
            last_py = p_y
            screen.drawCircleF(p_x,p_y,3)
        end
    end
end
--Report bugs/suggestions to Icewave#0394 on discord or https://github.com/Icewav3/Stormworks/issue