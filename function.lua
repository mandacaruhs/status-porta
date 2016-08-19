
function loop()

	period = 1000 * 10

	tmr.alarm(2, period, tmr.ALARM_AUTO, function()

		print("Iniciando novo loop...")

		-- ler status do sensor
		print(gpio.read(porta))
		status = "1"

		-- enviar status para API
		sendStatus(status)		

	end)
end

function sendStatus(status) print("Enviando status...")
	conn=net.createConnection(net.TCP, 0)
	data={}
	data["status"] = status
	json = cjson.encode(data)

	conn:on("connection", function(conn2,payload)
		conn:send("POST /dweet/for/mandacaruhs-door HTTP/1.1\r\n"..
				  "Host: https://dweet.io/\r\n"..
				  "Connection: keep-alive\r\n"..
				  "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua;)"..
				  "Accept: */*\r\n"..
				  "Content-Length: "..json:len().."\r\n"..
				  "Content-Type: application/json\r\n\r\n"..
				  json )
	end)

	conn:on("receive", function(conn, payload)
		print("Response mandacaruhs-door >> ")
		print(payload)
		conn:close()
		readMacAddresses()
	end)

	conn:connect(80, "dweet.io")
end

function readMacAddresses()
	conn=net.createConnection(net.TCP, 0)
	macs={}
	count=0

	conn:on("connection", function(conn,payload)
		print("Enviando...")
		conn:send("GET /userRpm/WlanStationRpm.htm HTTP/1.1\r\n"..
				  "Host: 192.168.1.1\r\n"..
				  "Authorization: Basic aGFja2VyOm1hbmRhY2FydQ==\r\n"..
				  "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua;)"..
				  "Accept: */*\r\n"..
				  "Referer: http://192.168.1.1/\r\n"..
				  "Connection: keep-alive\r\n"..
				  "\r\n")
	end)

	conn:on("receive", function(conn, payload)
		for address in string.gmatch(payload, '"([0-9A-Z][0-9A-Z]%-[0-9A-Z][0-9A-Z]%-[0-9A-Z][0-9A-Z]%-[0-9A-Z][0-9A-Z]%-[0-9A-Z][0-9A-Z]%-[0-9A-Z][0-9A-Z])"') do 
			macs[count] = address
			count = count + 1
		end

		if table.getn(macs) > 0 then
	 		conn:close()
	 		sendMacAddresses(cjson.encode(macs))
		end
	end)

	conn:connect(80, "192.168.1.1")
end

function sendMacAddresses(json)
	conn=net.createConnection(net.TCP, 0)

	conn:on("connection", function(conn,payload)
		conn:send("POST /dweet/for/mandacaruhs-macs HTTP/1.1\r\n"..
				  "Host: https://dweet.io/\r\n"..
				  "Connection: keep-alive\r\n"..
				  "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua;)"..
				  "Accept: */*\r\n"..
				  "Content-Length: "..json:len().."\r\n"..
				  "Content-Type: application/json\r\n\r\n"..
				  json )
	end)

	conn:on("receive", function(conn, payload)
		print("Response mandacaruhs-macs >> ")
		print(payload)
		conn:close()
	end)

	conn:connect(80, "dweet.io")
end