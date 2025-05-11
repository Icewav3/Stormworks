-- Percision positioning system

-- PID Constructor
function PID(p, i, d)
    return {
        p = p,
        i = i,
        d = d,
        i_out = 0,
        prev_err = 0,
        run = function(self, min_setpoint, setpoint, current)
            local out = 0
            if setpoint > min_setpoint then
                if current > setpoint * 0.1 + setpoint then
                    self.i_out = 0
                end
                local err = setpoint - current
                local p_out = err * self.p
                self.i_out = (err * self.i) + self.i_out
                local d_out = (err - self.prev_err) * self.d
                self.prev_err = err
                out = p_out + self.i_out + d_out
            end
            return out
        end
    }
end

-- Function to convert degrees to radians
function deg2rad(deg)
    return deg * math.pi / 180
end

-- Create memory and PIDs once
if memory == nil then
    memory = {}
    memory.target_x = 0
    memory.target_y = 0
    memory.pid_x = PID(1, 0.01, 0.3)
    memory.pid_y = PID(1, 0.01, 0.3)
end

function onTick()
    toggle_on = input.getBool(1)
    pitch_in = input.getNumber(2)
    roll_in = input.getNumber(3)
    compass = input.getNumber(4) -- degrees
    gps_x = input.getNumber(5)
    gps_y = input.getNumber(6)

    -- Output Variables
    local pitch_out = 0
    local roll_out = 0

    if toggle_on then
        -- Lock target position on activation
        if memory.target_locked ~= true then
            memory.target_x = gps_x
            memory.target_y = gps_y
            memory.target_locked = true
        end

        local dx = memory.target_x - gps_x
        local dy = memory.target_y - gps_y

        local heading = deg2rad(compass)
        local sin_h = math.sin(heading)
        local cos_h = math.cos(heading)

        -- Convert error to local space
        local local_x = dx * cos_h + dy * sin_h   -- Right/Left
        local local_y = -dx * sin_h + dy * cos_h  -- Forward/Back

        -- PID outputs with your pattern
        local pitch_correction = memory.pid_y:run(0.01, 0, local_y)
        local roll_correction = memory.pid_x:run(0.01, 0, local_x)

        pitch_out = pitch_correction
        roll_out = roll_correction
    else
        -- Reset lock and pass through control inputs
        memory.target_locked = false
        pitch_out = pitch_in
        roll_out = roll_in
    end

    -- Outputs
    output.setNumber(1, pitch_out)
    output.setNumber(2, roll_out)
end

-- Report bugs/suggestions to Icewave#0394 on Discord or https://github.com/Icewav3/Stormworks/issues
