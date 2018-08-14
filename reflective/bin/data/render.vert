#version 150

uniform mat4 modelViewProjectionMatrix;

in vec4 position;
//in vec2 texcoord;

out vec4 vPosition;

void main() {
	vPosition = vec4(position.xy, 1.0, 1.0);

    gl_Position = modelViewProjectionMatrix * position;
}
