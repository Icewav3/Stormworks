--v 0.1
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
--constants
pid1=PID(1, 0.01, 0.1)
pid2=PID(1, 0.01, 0.1)
pid3=PID(1, 0.01, 0.1)
pid4=PID(1, 0.01, 0.1)
target_pitch = 0
target_yaw = 0
target_roll = 0
target_updown = 0

function onTick()
    --inputs
    pitch_in = input.getNumber(1) or 0
    pitch_sensor = input.getNumber(2) or 0
    yaw_in = input.getNumber(3) or 0
    yaw_sensor = input.getNumber(4) or 0
    roll_in = input.getNumber(5) or 0
    roll_sensor = input.getNumber(6) or 0
    updown_in = input.getNumber(7) or 0
    updown_sensor = input.getNumber(8) or 0
    threshold = input.getNumber(9) or 0
    min_updown = input.getNumber(10) or 0
    --pitch
    if pitch_in <= -threshold or pitch_in >= threshold then
        pitch_out = pitch_in
        target_pitch = pitch_sensor
    else
        pitch_out = pid1:run(0, (target_pitch-pitch_sensor+0.25)%1-0.25)
    end
    --yaw
    if yaw_in <= -threshold or yaw_in >= threshold then
        yaw_out = yaw_in
        target_yaw = yaw_sensor
    else
        yaw_out = pid2:run(0, (target_yaw-yaw_sensor+0.5)%1-0.5)
    end
    --roll
    if roll_in <= -threshold or roll_in >= threshold then
        roll_out = roll_in
        target_roll = roll_sensor
    else
        roll_out = pid3:run(0, (target_roll-roll_sensor+0.25)%1-0.25)
    end
    --updown
    if updown_in <= -threshold or updown_in >= threshold then
        updown_out = updown_in
        target_updown = updown_sensor
    else
        updown_out = pid4:run(target_updown, updown_sensor)
        if updown_out < min_updown then
            updown_out = min_updown
        end 
    end
    --out
    output.setNumber(1,pitch_out)
    output.setNumber(2,yaw_out)
    output.setNumber(3,roll_out)
    output.setNumber(4,updown_out)
end
--Report bugs/suggestions to Icewave#0394 on discord or https://github.com/Icewav3/Stormworks/issue