-- Channels
-- input[1] = Setpoint
-- input[2] = TestPID output (control signal)
-- output[1] = Simulated Process Variable

-- Constants
local BUFFER_SIZE = 300 -- Max historical samples (updated based on screen width dynamically)

-- State
local timeIndex = 0
local setpointHistory = {}
local processHistory = {}

-- Settings
local processValue = 0
local processSpeed = 0.1  -- Adjust this for simulation responsiveness

function clamp(x, minVal, maxVal)
    return math.max(minVal, math.min(maxVal, x))
end

function onTick()
    local setpoint = input.getNumber(1)
    local control = input.getNumber(2)

    -- Simulate basic process: gradually approach setpoint based on control
    processValue = processValue + (control * processSpeed)
    processValue = processValue + (setpoint - processValue) * 0.01  -- add natural drift toward setpoint

    -- Store to history
    timeIndex = timeIndex + 1
    table.insert(setpointHistory, setpoint)
    table.insert(processHistory, processValue)

    -- Keep only screen-width worth of history
    if #setpointHistory > BUFFER_SIZE then
        table.remove(setpointHistory, 1)
        table.remove(processHistory, 1)
    end

    output.setNumber(1, processValue)
end

function onDraw()
    local w = screen.getWidth()
    local h = screen.getHeight()

    BUFFER_SIZE = w

    screen.setColor(0, 0, 0)
    screen.drawClear()

    -- 1. Find min/max
    local minVal, maxVal = math.huge, -math.huge
    for i = 1, #setpointHistory do
        minVal = math.min(minVal, setpointHistory[i], processHistory[i])
        maxVal = math.max(maxVal, setpointHistory[i], processHistory[i])
    end

    -- 2. Add margin for buffer
    local margin = (maxVal - minVal) * 0.1
    if margin < 0.5 then margin = 0.5 end
    minVal = minVal - margin
    maxVal = maxVal + margin

    -- Grid parameters
    local gridLineCount = 5
    local gridStep = (maxVal - minVal) / gridLineCount
    local verticalSpacing = w / 5  -- We want 5 vertical grid lines.

    -- Draw horizontal grid lines with labels
    screen.setColor(40, 40, 40)
    for i = 0, gridLineCount do
        local y = h * i / gridLineCount
        screen.drawLine(0, y, w, y)

        -- Draw horizontal labels (values)
        screen.setColor(255, 255, 255)
        screen.drawText(5, y, string.format("%.2f", minVal + i * gridStep))
    end

    -- Draw vertical grid lines
    screen.setColor(40, 40, 40)
    for i = 1, 5 do
        local x = verticalSpacing * i
        screen.drawLine(x, 0, x, h)
    end

    -- Plot from right to left
    for i = 2, #setpointHistory do
        local x1 = w - (#setpointHistory - i)
        local x2 = x1 + 1

        -- Map values to Y position
        local function mapToY(val)
            return clamp(h - ((val - minVal) / (maxVal - minVal)) * h, 0, h)
        end

        -- Draw Setpoint (Red)
        screen.setColor(255, 0, 0)
        screen.drawLine(x1, mapToY(setpointHistory[i-1]), x2, mapToY(setpointHistory[i]))

        -- Draw Process Variable (Green)
        screen.setColor(0, 255, 0)
        screen.drawLine(x1, mapToY(processHistory[i-1]), x2, mapToY(processHistory[i]))
    end

    -- Display current setpoint and process value
    screen.setColor(255, 255, 255)
    screen.drawText(1, 1, string.format("SP: %.1f PV: %.1f", setpointHistory[#setpointHistory] or 0, processHistory[#processHistory] or 0))
end

