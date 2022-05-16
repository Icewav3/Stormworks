function onTick()
    value = input.getNumber(1)
    ones=value%10
    tens=(value-ones)/10
    output.setNumber(1,tens)
    output.setNumber(2,ones)
end