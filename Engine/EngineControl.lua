--functions
function pid(p,i,d)
    return{p=p,i=i,d=d,E=0,D=0,I=0,
        run=function(s,sp,pv)
            local E,D,A
            E = sp-pv
            D = E-s.E
            A = math.abs(D-s.D)
            s.E = E
            s.D = D
            s.I = A<E and s.I +E*s.i or s.I*0.5
            return E*s.p +(A<E and s.I or 0) +D*s.d
        end
    }
end
function counter(desired,current,sensitivity,min,max)
    if counter_out == nil then
        counter_out = 0
    end
    if counter_out >= max then
        counter_out = max
    elseif current < desired then
        counter_out = counter_out + sensitivity
    elseif counter_out <= min then
        counter_out = min
    elseif current > desired then
        counter_out = counter_out - sensitivity
    end
    return counter_out
end

--constants
EngineThrottle = pid(0.01,0.00001,0.001)
airOut = 1
--get variables
function onTick()
    CurrentAir = input.getNumber(1)
    CurrentFuel = input.getNumber(2)
    AFR = CurrentAir/CurrentFuel
    Temp = input.getNumber(3)
    DesiredRPS = input.getNumber(4)
    CurrentRPS = input.getNumber(5)
    Charge = input.getNumber(6)

    -- Power generator
    if ((Charge < 0.25) and (Charge > 0.1)) then
        GeneratorRPS = 10
    else
        GeneratorRPS = 0
    end

    -- Engine throttler
    TargetRPS = math.max(GeneratorRPS,DesiredRPS)
    if TargetRPS < 3 then
        fuelOut = 0
        starter = 0
        goto output
    elseif Temp > 100 then
        fuelOut = 0
        starter = 0
    elseif CurrentRPS < 3 then
        starter = 1
    else
        throttleout = (EngineThrottle:run(TargetRPS, CurrentRPS))
        if throttleout > 0.5 then
            throttleout = 0.5
        end
        throttleout = math.abs(throttleout)
        airOut = counter(14,AFR,0.005)
        fuelOut = (throttleout)
        starter = 0
        --alternator
        if Charge > 0.9 then
            alternator = 0
        else
            alternator = 1
        end
    end
    ::output::
    output.setNumber(1,airOut)
    output.setNumber(2,fuelOut)
    output.setBool(1,starter)
    output.setNumber(3,alternator)
    output.setNumber(4,CurrentRPS)
    output.setNumber(5,AFR)
    output.setNumber(6,throttleout)
    output.setNumber(7,AFRtweak)
end
--Report bugs to Icewave#0394