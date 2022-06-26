function within(x,target,range)
    x=math.abs(x)
    if x < target+range then
      out=true
    else
      out=false
    end
    return out
end