--functions
function isPointInRectangle(x, y, rectX, rectY, rectW, rectH)
	return x > rectX and y > rectY and x < rectX+rectW and y < rectY+rectH
end

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

    if north == true then
        y_offset = y_offset + 1
    elseif south == true then 
        y_offset = y_offset - 1
    elseif east == true then
        x_offset = x_offset + 1
    elseif west == true then
        x_offset = x_offset - 1
    else
    end

    --[[screen.drawRectF(0, 0, s_w, s_h*Uiscale)
    screen.drawRectF(0, 0, s_w*Uiscale, s_h)
    screen.drawRectF(s_w-(Uiscale*s_w), 0, s_w*Uiscale, s_h)
    screen.setColor(255, 0, 0)
    screen.drawRectF(0, s_h-(Uiscale*s_h), s_w, s_h*Uiscale)]]--
end