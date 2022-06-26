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
                self.i_out = self.i_out/2
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
pid1=PID(0.1,0,0)
pi=math.pi
function onTick()
    veh_x=input.getNumber(1)
    veh_y=input.getNumber(2)
    compass=input.getNumber(3)
    tar_x=input.getNumber(4)or 0
    tar_y=input.getNumber(5)or 0
    alt=input.getNumber(6)or 0
    speed=input.getNumber(7)or 0
    fwd_in=input.getNumber(8)or 0
    yaw_in=input.getNumber(9)or 0
    up_in=input.getNumber(10)or 0
    if tar_x == 0 and tar_y == 0 then
        yaw=yaw_in
        fwd=fwd_in
        up=up_in
    else
        xdiff=tar_x-veh_x
        ydiff=tar_y-veh_y
        radians=math.atan(ydiff, xdiff)
        heading=wrap(compass*180/pi,0,pi*2)
        angle=wrap(radians,-0.5,0.5)
        yaw=pid1:run(angle, heading)
    end
    output.setNumber(1,wp_num)
    output.setNumber(2,yaw)
    output.setNumber(3,fwd)
    output.setNumber(4,up)
    output.setNumber(5,ETA)
end