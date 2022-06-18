function onTick()
    x = input.getNumber(1)
    y = input.getNumber(2)
    z = input.getNumber(3)

end
function onDraw()
	s_w = screen.getWidth()
	s_h = screen.getHeight()
    screen.drawMap(x, y, 5)
    --zoom buttons
    Uiscale = 1/8
    offset = 1
    screen.setColor(0, 255, 0, 50)
    screen.drawTriangleF(0+offset, s_h*Uiscale, s_w*Uiscale/2+offset, 0+offset, s_w*Uiscale+offset, s_h*Uiscale)
    screen.setColor(255, 0, 0, 50)
    screen.drawTriangleF(0+offset, s_h*Uiscale+offset, s_w*Uiscale/2+offset, s_h*Uiscale*2, s_w*Uiscale+offset, s_h*Uiscale+offset)
    --screen.drawTriangle(x1, y1, x2, y2, x3, y3)
end