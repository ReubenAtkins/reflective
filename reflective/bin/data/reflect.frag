#version 150

uniform sampler2DRect txture;
uniform vec2 screen;
in vec2 vTexCoord;

out vec4 vFragColor;

void main() {
	vFragColor = vec4(1.0, 0.0, 0.0, 1.0);
}
