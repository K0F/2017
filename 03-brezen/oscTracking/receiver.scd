

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
  fx = DWGReverb3Band.ar(NumChannels.ar(fx,2),[5000,5010],1/len)/rev;
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
        //var mod = Duty.kr(~tempo*[4,3,2],0,Dseq([1,2,1.5,1.33333],inf));
        //var notes = [60,36,72,84,64,65,69,67,55,65,67,61].midicps;
        //var sel = Select.kr(x*notes.size,notes);
        var sig = Formant.ar(50,x * 5000 * [1,2,4],y * 5000 * [1,2,4,1.5]);
        sig = Resonz.ar(sig,x.range(50/4,500*[1,2,4,8]),0.01+a);
        sig = Normalizer.ar(sig) * a;
        sig = sig * Pulse.ar(~tempo*2/[1,2,3,4]);
        //sig = CombN.ar(sig,1/(50),1/(50+y),1/2);
        
        //a.poll;
        Splay.ar(sig,0.5,0.25);
    };
    ~sonify_one.play;
);
~sonify_one.stop(4);
~sonify_one.clear;
~sonify_one.pause;
~sonify_one.resume;

// kick synth ///////////////////////////////////////

(
~kick.ar(2);
~kick.clock = p.clock;
~kick.quant=[16,0];
~kick.fadeTime=0.02;
~kick={
  //  |       |       |       |       |  
  var pat = [
    1,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
    1,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
    1,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
    1,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
  ].rotate(1);
  var imp = PulseDivider.kr(~tick.kr,1,~counter.kr%pat.size);
  var hit = Select.kr(PulseCount.kr(imp)%pat.size,pat);
  var env = EnvGen.ar(Env([0.001,1,0.0001],[0.002,1.5],[3,-3]),imp * hit);
  var sig = SinOsc.ar(50!2,env**50*8pi);
  sig = sig * env;
  Splay.ar(sig,0.75,0.5);
};
~kick.play;
);
~kick.stop(4);
~kick.clear;
~kick.pause;
~kick.resume;
