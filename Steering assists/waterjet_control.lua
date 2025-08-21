function onTick()
    ws=input.getNumber(1)
    ad=input.getNumber(2)
    lr=input.getNumber(3)
    if lr < 0 then --left
        la, ra = 1, 1-lr
        lb, rb = 0+lr, 1
    else
        la, ra = 0+lr, 1
        lb, rb = 1, 1-lr
    end
    if ws < 0 then
        la, ra = math.abs(ws) + ad, math.abs(ws) + ad
        lb, rb = math.abs(ws) - ad, math.abs(ws) - ad
    else
        la, ra = ad, ad
        lb, rb = ad*-1, ad*-1
    end
    output.setNumber(1,la)
    output.setNumber(2,lb)
    output.setNumber(3,ra)
    output.setNumber(4,rb)
end