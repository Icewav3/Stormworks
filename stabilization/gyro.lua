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
--constants
pid1=PID(1, 0.01, 0.1)
pid2=PID(1, 0.01, 0.1)
target_h = 0
target_p = 0
function onTick()
    steering = input.getNumber(1)
    compass = input.getNumber(2)
    threshold = input.getNumber(3)
    tiltsensor = input.getNumber(4)
    pitchin = input.getNumber(5)
    if pitchin <= -threshold or pitchin >= threshold then
        pitch_out = pitchin
        target_p = tiltsensor
    else
        pitch_out = pid2:run(0, (target_p-tiltsensor+0.25)%1-0.25)
    end
    if steering <= -threshold or steering >= threshold then
        steer_out = steering
        target_h = compass
    else
        steer_out = pid1:run(0, (target_h-compass+0.5)%1-0.5)
    end
    output.setNumber(1,steer_out)
    output.setNumber(2,pitch_out)
end
--Report bugs/suggestions to Icewave#0394 on discord or https://github.com/Icewav3/Stormworks/issue