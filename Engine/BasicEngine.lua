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
        function counter(desired,current,sensitivity)
            if counter_out == nil then
                counter_out = current
            end
            if current < desired then
                counter_out = counter_out + sensitivity
            else
                counter_out = counter_out - sensitivity
            end
            return counter_out
        end
