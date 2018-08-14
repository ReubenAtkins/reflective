#version 150
#define TAU 6.2831853071
layout (points) in;
layout (triangle_strip) out;
layout (max_vertices = 18) out;

uniform mat4 modelViewProjectionMatrix;
uniform float r;



in vec4 vPosition[];

out vec2 vTexCoord;

void main(void){
	float rt = sqrt(3.0)/2.0;
    // For each vertex moved to the right position on the vertex shader
    // it makes 6 more vertex that makes 2 GL_TRIANGLE_STRIP
    // that´s going to be the frame for the pixels of the sparkImg texture
    //
    for(int i = 0; i < gl_in.length(); i++){
		for (float j = 0; j < 6.0; j++) {
			gl_Position = modelViewProjectionMatrix * (vPosition[i]);
			vTexCoord.x = .5;
			vTexCoord.y = .5;
			EmitVertex();
			for(float k = 0; k < 2.0; k++) {
				float x = cos(TAU * (k+j)/6.0);
				float y = sin(TAU*(k+j)/6.0);
				gl_Position = modelViewProjectionMatrix*(vPosition[i]+vec4(x*r, y*r, 0.0, 0.0));
				if( mod(j+k, 2.0) > .5) {
					vTexCoord.x = 1.0;
					vTexCoord.y = 0.0;
				} else {
					vTexCoord.x = 0.0;
					vTexCoord.y = 0.0;
				}
				EmitVertex();			
			}
			EndPrimitive();
		}
	}
}