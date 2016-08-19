
wifi.setmode(wifi.STATION)
wifi.sta.config("MANDACARU HS", "hackerspace")
wifi.sta.connect()
tmr.alarm(1, 1000, 1, function()
      if wifi.sta.getip() == nil then
         print("Conectando, Aguarde... ")
      else
        tmr.stop(1)
        print("Conectado, IP: "..wifi.sta.getip())
        setstatus(tostring(1))
      end
   end)


