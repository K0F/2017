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
  intensity = max(0.0, dot(vertLightDir, vertNormal)) ;

 // color = vec4(intensity * 8.0 * (vertLightDir),1.0);//vec4( 1.0 - (vec3(10.0) * pow((vertLightDir.x+vertLightDir.y+vertNormal.z)/3.0,1.5)),1.0);
 color = vec4(sin(tt*vertLightDir.xyz/(sin(tt/100.1)*2000.0)+tt) * cos(vertNormal.x*tt/10.0+tt) * sin(vertColor.x/100.0+tt),intensity);

  gl_FragColor = vertColor * color;
}
