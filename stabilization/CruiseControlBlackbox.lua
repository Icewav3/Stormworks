--v 1.4
-- added blackbox
-- improved hover
-- onoff now resets values
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
    is_on = input.getBool(11)
    pitch_in = input.getNumber(1) or 0
    yaw_in = input.getNumber(3) or 0
    roll_in = input.getNumber(5) or 0
    updown_in = input.getNumber(7) or 0
    -- simple blackbox functionality
    updown_sensor = input.getNumber(8) or 0
    if is_on == true and updown_sensor > 0 then
        --inputs
        pitch_sensor = input.getNumber(2) or 0
        yaw_sensor = input.getNumber(4) or 0
        roll_sensor = input.getNumber(6) or 0
        threshold = input.getNumber(9) or 0
        min_updown = input.getNumber(10) or 0
        --pitch
        if pitch_in <= -threshold or pitch_in >= threshold then
            pitch_out = pitch_in
            target_pitch = pitch_sensor
            pitch_control = false
        else
            pitch_out = pid1:run(0, (target_pitch-pitch_sensor+0.25)%1-0.25)
            pitch_control = true
        end
        --yaw
        if yaw_in <= -threshold or yaw_in >= threshold then
            yaw_out = yaw_in
            target_yaw = yaw_sensor
            yaw_control = false
        else
            yaw_out = pid2:run(0, (target_yaw-yaw_sensor+0.5)%1-0.5)
            yaw_control = true
        end
        --roll
        if roll_in <= -threshold or roll_in >= threshold then
            roll_out = roll_in
            target_roll = roll_sensor
            roll_control = false
        else
            roll_out = pid3:run(0, (target_roll-roll_sensor+0.25)%1-0.25)
            roll_control = true
        end
        --updown
        if updown_in <= -threshold or updown_in >= threshold then
            updown_out = updown_in
            target_updown = updown_sensor
            updown_control = false
        else
            updown_out = pid4:run(target_updown, updown_sensor)
            if updown_out < min_updown then
                updown_out = updown_out / 2
            end 
            updown_control = true
        end
    else
        target_pitch = 0
        target_yaw = 0
        target_roll = 0
        target_updown = updown_sensor
        pitch_out = pitch_in
        yaw_out = yaw_in
        roll_out = roll_in
        updown_out = updown_in
    end
    --out
    output.setBool(1, pitch_control and is_on)
    output.setBool(2, yaw_control and is_on)
    output.setBool(3, roll_control and is_on)
    output.setBool(4, updown_control and is_on)
    output.setNumber(5,pitch_out)
    output.setNumber(6,yaw_out)
    output.setNumber(7,roll_out)
    output.setNumber(8,updown_out)
    output.setNumber(9,target_pitch)
    output.setNumber(10,target_yaw)
    output.setNumber(11,target_roll)
    output.setNumber(12,target_updown)
end
--Report bugs/suggestions to Icewave#0394 on discord or https://github.com/Icewav3/Stormworks/issue