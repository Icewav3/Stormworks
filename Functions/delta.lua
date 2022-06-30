function delta(value)
    lastvalue=lastvalue or 0
    out = value- lastvalue
    lastvalue=value
    return out
end