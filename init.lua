dofile("function.lua")
dofile("configgpio.lua")

wifi.setmode(wifi.STATION)
wifi.sta.config("Mandacaru HS", "hackerspace2016")
wifi.sta.connect()

readingSensor = 0
statusSensor = 0

tmr.alarm(0, 1000, 1, function()
    if wifi.sta.getip() == nil then
        print("Conectando ao Wi-Fi, aguarde... ")
    else
        tmr.stop(0)
        print("Conectado! IP: "..wifi.sta.getip())
        
        gpio.trig(porta, "both", function(level)
            if readingSensor == 0 then
                readingSensor = 1
                tmr.alarm(1, 1000, tmr.ALARM_SINGLE, read_sensor)
            end
        end)
    end
end)

function read_sensor()
    local statusSensor = gpio.read(porta)
    
    if statusSensor == 1 then closing() else opening() end
    readingSensor = 0
end

function opening()
    local running, mode = tmr.state(2)
    local period = 1000 * 60 * 5
    
    if not running then
        print('abrindo...')
        tmr.alarm(2, period, tmr.ALARM_AUTO, open_check)
    end
end

function closing()
    local running, mode = tmr.state(2)
    
    if running then
        print('fechando...') 
        tmr.unregister(2) 
    end
    
    sendStatus(0)
end

function open_check()
    local status = gpio.read(porta)
    
    if status == 0 then
        print('aberto')
        sendStatus(1)
    end
end