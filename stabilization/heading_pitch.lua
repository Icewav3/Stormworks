--[[
    Stormworks Lua Script: Heading & Pitch Hold with PID Control
    Author: Icewave#0394
    Description:
        This script provides heading and pitch hold functionality using two PID controllers.
        When manual input is detected (beyond a defined threshold), the system passes through the input.
        Otherwise, it holds the last heading or pitch using PID control.
--]]

-- PID controller factory function
-- p, i, d: proportional, integral, and derivative gains
function PID(p, i, d)
    return {
        p = p,
        i = i,
        d = d,
        i_out = 0,       -- Accumulated integral output
        prev_err = 0,    -- Error from the previous run, for derivative calculation

        -- PID execution method
        -- setpoint: the desired value
        -- current: the current measured value
        run = function(self, setpoint, current)
            -- Prevent integral windup if too far from setpoint
            if current > setpoint * 0.1 + setpoint then
                self.i_out = 0
            end

            -- Calculate error
            err = setpoint - current

            -- Proportional term
            p_out = err * self.p

            -- Integral term
            self.i_out = (err * self.i) + self.i_out

            -- Derivative term
            d_out = (err - self.prev_err) * self.d
            self.prev_err = err

            -- Total PID output
            out = p_out + self.i_out + d_out
            return out
        end
    }
end

-- Initialize two PID controllers: one for heading (pid1), one for pitch (pid2)
-- Tune these values based on your vehicle's responsiveness
pid1 = PID(1, 0.01, 0.1) -- Heading PID
pid2 = PID(1, 0.01, 0.1) -- Pitch PID

-- Target values for heading and pitch to hold
target_h = 0
target_p = 0

-- Main update function called every game tick
function onTick()
    -- Read inputs from the game:
    steering = input.getNumber(1)     -- Manual heading control input
    compass = input.getNumber(2)      -- Current heading (0.0–1.0)
    threshold = input.getNumber(3)    -- Threshold beyond which manual input is considered
    tiltsensor = input.getNumber(4)   -- Current pitch sensor value (0.0–1.0)
    pitchin = input.getNumber(5)      -- Manual pitch control input

    -- Pitch control logic
    if pitchin <= -threshold or pitchin >= threshold then
        -- Manual input detected: bypass PID, use direct input
        pitch_out = pitchin
        target_p = tiltsensor -- Update target to current for holding later
    else
        -- Automatic PID control to maintain target pitch
        pitch_out = pid2:run(0, (target_p - tiltsensor + 0.25) % 1 - 0.25)
    end

    -- Heading control logic
    if steering <= -threshold or steering >= threshold then
        -- Manual input detected: bypass PID, use direct input
        steer_out = steering
        target_h = compass -- Update target to current for holding later
    else
        -- Automatic PID control to maintain target heading
        steer_out = pid1:run(0, (target_h - compass + 0.5) % 1 - 0.5)
    end

    -- Output the resulting control signals
    output.setNumber(1, steer_out) -- Heading control output
    output.setNumber(2, pitch_out) -- Pitch control output
end

-- Report bugs/suggestions to Icewave#0394 on Discord or https://github.com/Icewav3/Stormworks/issues
