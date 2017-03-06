

p.push();
p.bpm(90);

(
    OSCdef(\receiver,{arg ... args;
        ~sonify_one.set(\x,args[0][1]);
        ~sonify_one.set(\y,args[0][2]);
        ~sonify_one.set(\a,args[0][3]);
    },\live);

  ~master.quant=2;
  ~master.play;
  ~master.fadeTime = 0.01;
  ~master = {|wet=0.35,lp=3500,hp=250,len=10,rev = 3|
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
p.moveNodeToTail(\master);
);

// sonify_one synth ///////////////////////////////////////

(
    ~sonify_one.ar(2);
    ~sonify_one.clock = p.clock;
    ~sonify_one.quant=4;
    ~sonify_one.fadeTime=1;
    ~sonify_one={|x=0,y=0,a=0|
        var mod = Duty.kr(~tempo*[4,3,2],0,Dseq([1,2,1.5,1.33333],inf));
        var notes = [60,36,72,84,64,65,69,67,55,65,67,61].midicps;
        var sel = Select.kr(x*notes.size,notes);
        var sig = SinOsc.ar(sel);
        //sig = Resonz.ar(sig,x.range(sel/4,sel*[1,2,4,8]),y+0.01);
        sig = sig * Pulse.ar(~tempo*4*y);
        //sig = CombN.ar(sig,1/(y*note),1/(y*note),2);
        //[x,y,a].poll;
        //a.poll;
        Splay.ar(sig,0.5,0.15);
    };
    ~sonify_one.play;
);
~sonify_one.stop(4);
~sonify_one.clear;
~sonify_one.pause;
~sonify_one.resume;

//  synth ///////////////////////////////////////

(
~.ar(2);
~.quant=2;
~.fadeTime=0.2;
~={
  //         |       |       |       |       |  
  var pat = [1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0].rotate(1);
  var imp = PulseDivider.kr(~tick.kr,1,~counter.kr % pat.size);
  var hit = Select.kr(PulseCount.kr(imp)%pat.size,pat);
  var env = EnvGen.ar(Env([0.001,1,0.0001],[0.002,0.5],[3,-3],curve:'exp'),imp * hit);
  var sig = [
  SinOsc.ar(50!2),
  ];
  sig = Select.ar(PulseCount.kr(imp*hit)%sig.size,sig);
  sig = sig * env;
  Splay.ar(sig,0.75,0.5);
};
~.play;
);
~.stop(4);
~.clear;
~.pause;
~.resume;

