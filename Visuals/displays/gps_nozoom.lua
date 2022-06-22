--functions
function isPointInRectangle(x, y, rectX, rectY, rectW, rectH)
    return x > rectX and y > rectY and x < rectX+rectW and y < rectY+rectH
end
function PID(p, i, d)
    return {
        p = p,
        i = i,
        d = d,
        i_out = 0,
        prev_err = 0,
        run = function(self, setpoint, current)
            if current > setpoint * 0.1 + setpoint then
                self.i_out = 0
            end
            err = setpoint - current
            p_out = err * self.p
            self.i_out = (err * self.i) + self.i_out
            d_out = (err - self.prev_err) * self.d
            self.prev_err = err
            out = p_out + self.i_out + d_out
            return out
        end
    }
end
waypoints={}
pid1=PID(1, 0.01, 0.1)
pid2=PID(1, 0.01, 0.1)
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
    yaw = input.getNumber(8) or 0
    fwd = input.getNumber(9) or 0
    updown = input.getNumber(9) or 0
    if #waypoints > 0 then
        if tar_alt ~= nil then
            num=num or 1
            for n=num, #waypoints, 2 do
                tar_x = waypoints[n]
                tar_y = waypoints[n+1]
            end
            xd = tar_x - veh_x
            yd = tar_y - veh_y
            if xd < 5 and xd > -5 and yd < 5 and yd > -5 then --close to tar?
                num=num+2
            else
                compass = compass*math.pi*2
                dist = math.sqrt(yd^2+xd^2)
                angle = math.atan(yd, xd)
                yaw_out = pid1:run(angle, compass)
                updown_out = pid2:run(tar_alt or 100, alt)
                fwd_out = 1
            end
        else
            tar_alt = alt
        end
    else
        yaw_out = yaw
        fwd_out = fwd
        updown_out = updown
        tar_alt = nil
    end
    output.setNumber(1,yaw_out)
    output.setNumber(2,fwd_out)
    output.setNumber(3,updown_out)
    output.setNumber(4,angle)
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
    screen.setColor(255,0,0,75)
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