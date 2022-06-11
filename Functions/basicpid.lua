function PID(p, i, d) 
    return {
      p = p, 
      i = i, 
      d = d,
      i_out = 0, 
      prev_err=0, 
      function run(self, setpoint, current)
        if current > setpoint*0.1 + setpoint then
            self.i_out = 0
        end
        err = setpoint - current
        p_out = err * self.p
        self.i_out = (err * self.i) + self.i_out
        d_out = (err - self.prev_err) * self.d
        self.prev_err = err
        out = p_out + self.i_out + d_out
      return out
    end
   } 
  end
  pid1=PID(0.2,0.0001,0.1)
function onTick()
    Setpoint = input.getNumber(1)
    Current = input.getNumber(2)
    throttle = pid1:run(Setpoint, Current)
    output.setNumber(1,throttle)
end