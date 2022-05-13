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
--constants
EngineThrottle = pid(0.1,0, 0)
AFR = input.getNumber(7)
Air = (AFR)
Fuel = (1-AFR)
-- Engine throttler
function onTick()
	Air = input.getNumber(1)
	Fuel = input.getNumber(2)
	Temp = input.getNumber(3)
	DesiredRPS = input.getNumber(4)
	CurrentRPS = input.getNumber(5)
    Charge = input.getNumber (6)
    TargetRPS = math.max(GeneratorRPS, DesiredRPS)
    if DesiredRPS < 5 then
        -- Power generator
        if (0.25 <=Charge=> 0.1 <)
        GeneratorRPS = 10
        else
        end
        airOut = 0
        fuelOut = 0
        starter = 0
    elseif Temp > 100 then
        airOut = 0
        fuelOut = 0
        starter = 0
	elseif CurrentRPS < 3 then
		starter = 1
    else
        throttleout = (EngineThrottle:run(TargetRPS, CurrentRPS))
        fuelOut = Fuel*throttleout
        airOut = Air*throttleout
        starter = 0
        --alternator
        if Charge > 0.9
            alternator = 0
        else
            alternator = 1
        end
    end
    
--outputs
output.setNumber(1,airOut)
output.setNumber(2,fuelOut)
output.setBool(1,starter)
output.setNumber(3,alternator)
end