function onTick()
	rod_temp=input.getNumber(1)
    boiler_temp=input.getNumber(2)
    boiler_pressure=input.getNumber(3)
    control_rod=delta(rod_temp)
    output.setNumber(1,control_rod)
	output.setNumber(2,turbine_overflow)
end