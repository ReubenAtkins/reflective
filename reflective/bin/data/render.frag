#version 150

// This fill the billboard made on the Geometry Shader with a texture

uniform sampler2DRect txture;
uniform vec2 screen;
in vec2 vTexCoord;

out vec4 vFragColor;

void main() {
    vFragColor = texture(txture, vTexCoord*screen);
	//vFragColor = vec4(1.0, 1.0, 0.0, 1.0);
}
