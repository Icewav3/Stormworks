function wrap(x, min, max)
    return (x - min) % (max - min) + min
end
function within(x,target,range)
    x=math.abs(x)
    target=math.abs(target)
    if x < target+range then
      out=true
    else
      out=false
    end
    return out
end
function PID(p, i, d)
    return {
        p = p,
        i = i,
        d = d,
        i_out = 0,
        prev_err = 0,
        run = function(self, setpoint, current)
            if current > setpoint * 0.25 + setpoint then
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
pid1=PID(1,0,0)
pid2=PID(1,0.01,0.1)
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
    wp_num=wp_num or 0
    if tar_x == 0 and tar_y == 0 then
        yaw=yaw_in
        fwd=fwd_in
        up=up_in
        target_alt=alt
        wp_num=0
    else
arrive = within(veh_x,tar_x,25) and within(veh_y,tar_y,25)
if arrive and not last then
    wp_num=wp_num+1
else end
last=arrive
xdiff=tar_x-veh_x
ydiff=tar_y-veh_y
distance=math.sqrt(ydiff^2+xdiff^2)
angle=math.atan(ydiff, xdiff)
heading=wrap(compass*180/pi,0,pi*2)
angle=wrap(angle,-0.5,0.5)
yaw=pid1:run(0, (angle-compass+0.5)%1-0.5)
        up=pid2:run(target_alt, alt)
        fwd=1
        ETA=distance/speed
    end
    output.setNumber(1,wp_num)
    output.setNumber(2,yaw)
    output.setNumber(3,fwd)
    output.setNumber(4,up)
    output.setNumber(5,angle)
end
--Report bugs/suggestions to Icewave#0394 on discord or https://github.com/Icewav3/Stormworks/issues