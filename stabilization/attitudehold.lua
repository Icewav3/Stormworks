-- Smart Altitude hold
-- NEEDS TESTING
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
function clamp(x, min, max)
    return math.max(min, math.min(max, x))
end

--constants
P = property.getNumber("P") or 1
I = property.getNumber("I") or 0.01
D = property.getNumber("D") or 0.1
sensitivity = property.getNumber("Sensitivity") or 0.1
is_heli = property.getBool("IsHelicopter")

if is_heli then
    min_clamp = -1
    min_setpoint = property.getNumber("MinSetpointHeli")
else
    min_clamp = 0
    min_setpoint = property.getNumber("MinSetpointPlane")
end

pid1 = PID(P, I, D)


-- tick
function onTick()
    current_input = input.getNumber(1)
    current_altitude = input.getNumber(2)

    -- Main logic
    if math.abs(current_input) > sensitivity then
        control_axis_out = current_input
        target_altitude = current_altitude
    else
        -- alt hold
        control_axis_out = pid1:run(min_setpoint, target_altitude, current_altitude)
    end
    --out
    output.setNumber(1, clamp(control_axis_out, min_clamp, 1))
end
--Report bugs/suggestions to Icewave#0394 on discord or https://github.com/Icewav3/Stormworks/issue