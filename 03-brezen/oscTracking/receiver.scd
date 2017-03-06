


(
    ~live.quant=0;
    ~live.fadeTime=0;
    OSCdef(\receiver,{arg ...args;
        ~live={|x,y,amp|
            x = args[0][1];
            y = args[0][2];
            amp = args[0][3];
            [] ++ [x,y,amp];
        };
    },"/live");
)


~live.poll;
