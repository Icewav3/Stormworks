function wrap(x, min, max)
    return (x - min) % (max - min) + min
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
function onTick()
    veh_x = input.getNumber(1) or 0
    veh_y = input.getNumber(2) or 0
    z = input.getNumber(3) or 5
    zoom = input.getNumber(4) or 0
end
function onDraw()
	s_w = screen.getWidth()
	s_h = screen.getHeight()
    x = veh_x + x_offset
    y = veh_y + y_offset
    screen.drawMap(x, y, zoom)
    --zoom buttons
    Uiscale = 1/8
    offset = 1
    screen.setColor(0, 255, 0, 50)
    screen.drawTriangleF(0+offset, s_h*Uiscale, s_w*Uiscale/2+offset, 0+offset, s_w*Uiscale+offset, s_h*Uiscale)
    screen.setColor(255, 0, 0, 50)
    screen.drawTriangleF(0+offset, s_h*Uiscale+offset, s_w*Uiscale/2+offset, s_h*Uiscale*2, s_w*Uiscale+offset, s_h*Uiscale+offset)
    --screen.drawTriangle(x1, y1, x2, y2, x3, y3)
end