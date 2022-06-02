function add(a,b)
    return {
        a = a,
        b = b,
        total = 0,
        run = function(a,b)
            local total = a + b
            return total
        end
    }
end
Function1 = add(2, 3)
print = (Function1:run(1,3))