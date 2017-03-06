

p.push();
p.bpm(60);

(
    OSCdef(\receiver,{arg ... args;
        ~sonify_one.set(\x,args[0][1]);
        ~sonify_one.set(\y,args[0][2]);
        ~sonify_one.set(\a,args[0][3]);
    },\live);
)

NodeProxy.help;
OSCdef.help;


(
  ~master.quant=2;
  ~master.play;
  ~master.fadeTime = 0.01;
  ~master = {|wet=0.15,lp=3500,hp=250,len=10,rev = 3|
  var sig = In.ar([0,1]);
  var orig = sig;
  var fx;
  //fx = Limiter.ar(sig,0.95);
  sig = CompanderD.ar(sig,3/4,1/1.1,1/3);
  fx = LPF.ar(sig,lp);
  fx = HPF.ar(fx,hp);
  fx = DWGReverb.ar(NumChannels.ar(fx,2),[5000,5010],1/len)/rev;
  sig = SelectX.ar(wet,[orig,fx]);
  sig = NumChannels.ar(sig,2);
  ReplaceOut.ar(0,sig);
  };
);
p.moveNodeToTail(\master);

// sonify_one synth ///////////////////////////////////////

(
    ~sonify_one.ar(2);
    ~sonify_one.clock = p.clock;
    ~sonify_one.quant=4;
    ~sonify_one.fadeTime=4;
    ~sonify_one={|x=0,y=0,a=0|
        var note = 36.midicps;
        var env = Pulse.ar(y*~tempo*50).softclip*2;
        var sig = VarSaw.ar(y.range(1,2000) + (env**(20)+(x*200)),0,env**(20)*8pi) * env;
        sig = Resonz.ar(sig,x.range(note/4,note*4),y+0.001);
        sig = Normalizer.ar(sig) * env;
        sig = CombN.ar(sig,1/(y*note),1/(y*note),1/3);
        [x,y,a].poll;
        Splay.ar(sig,0.5,0.95);
    };
    ~sonify_one.play;
);
~sonify_one.stop(4);
~sonify_one.clear;
~sonify_one.pause;
~sonify_one.resume;

