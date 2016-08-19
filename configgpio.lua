gpiolookup = {[0]=3,
              [1]=10,
              [2]=4,
            --[3]=9,Essa porra é o rx do ESP8266, não descomentar NUUUUUUNCA
              [4]=1,
              [5]=2,
              [10]=12,
              [12]=6,
              [13]=7,
              [14]=5,
              [15]=8,
              [16]=0}

porta = gpiolookup[4]
gpio.mode(porta, gpio.INT)