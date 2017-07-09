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
  intensity = max(0.0, dot(vertLightDir, vertNormal));

  color = vec4( 1.0 - (vec3(20.0) * pow((vertLightDir.x+vertLightDir.y+vertLightDir.z)/3.0,3.5)),1.0);

  gl_FragColor = vertColor * color * intensity;
}
