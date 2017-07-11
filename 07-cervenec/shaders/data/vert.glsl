
uniform mat4 transform;
uniform mat3 normalMatrix;
uniform vec3 lightNormal;

attribute vec4 position;
attribute vec4 color;
attribute vec3 normal;

uniform float tt;

varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;

void main() {
  gl_Position = transform * position * vec4(sin(normal/10.0+tt/20.0) * sin(tt/10.0),1.0);
  vertColor = (color);
  vertNormal = normalize(normalMatrix * normal);
  vertLightDir = normal;
}
