
// processing sketch is in /2017/seed2017

p.push();
OpenObject.start
OpenObject.openInterpreter;


(
    ~master.quant=2;
    ~master.play;
    ~master.fadeTime = 0.01;
    ~master = {|wet=0.05,lp=3500,hp=250,len=10,rev = 3|
        var sig = In.ar([0,1]);
        var orig = sig;
        var fx;
        //fx = Limiter.ar(sig,0.95);
        sig = Compander.ar(sig,3/4,1/1.1,1/3);
        fx = LPF.ar(sig,lp);
        fx = HPF.ar(fx,hp);
        fx = DWGReverb.ar(NumChannels.ar(fx,2),[5000,5010],1/len)/rev;
        sig = SelectX.ar(wet,[orig,fx]);
        sig = NumChannels.ar(sig,2);
        ReplaceOut.ar(0,sig);
    };
    p.moveNodeToTail(\master);
);

// idiom synth ///////////////////////////////////////

(
    ~idiom.ar(2);
    ~idiom.clock = p.clock;
    ~idiom.quant=2;
    ~idiom.fadeTime=0.1;
    ~idiom={|x=0.5,y=0.5,ax=0.5,ay=0.5|
        //////////////////////////   interpolation
        var mel = Duty.kr(4,0,Dseq([1,2,1.5,1.33333],inf));
        var ins = [ax,ay].lag(1/30);
        var ins2 = [ax,ay].lag(1/30);
       var sig = WhiteNoise.ar(1!2) * ins;
        sig = BPF.ar(sig,1500,LFTri.kr(1000*ins).range(0.1,0.5));
        sig = CompanderD.ar(sig,3/4,1/2,1/2);
        //sig = Perlin3.ar(sig[0],sig[1],sig[2]) * ins;
        //sel = sig * SinOsc.ar(Select.kr(ins*freqs.size,freqs));// * SinOsc.ar(freqs+ins);

        Splay.ar(sig,0.5,0.5,SinOsc.kr(29.97/2)/2);
    };
    ~idiom.play;
);
~idiom.stop(60);
~idiom.clear;
~idiom.pause;
~idiom.resume;


~idiom.publish(\idiom);
