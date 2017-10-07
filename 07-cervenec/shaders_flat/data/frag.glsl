#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform float fraction;
uniform float tt;

varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;

void main() {
  float intensity;
  vec4 color;
  float dd = distance(vec2(gl_FragCoord.x,gl_FragCoord.y),vec2(0.0,0.0));
  gl_FragColor = vec4(sin(tt*10.0/1.0),sin(tt*10.0/1.001),sin(tt*10.0/1.0001),1.0);
}
