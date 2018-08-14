#version 150

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
	
		//0 1 2
        gl_Position = modelViewProjectionMatrix * ( vPosition[i] );
        vTexCoord.x = 0.5;
        vTexCoord.y = 0.5;
        EmitVertex();

        gl_Position = modelViewProjectionMatrix * (vPosition[i] + vec4(-r/2.0,-rt*r,0.0,0.0));
        vTexCoord.x = 0.0;
        vTexCoord.y = 0.0;
        EmitVertex();

        gl_Position = modelViewProjectionMatrix * (vPosition[i] + vec4(r/2.0,-rt*r,0.0,0.0));
        vTexCoord.x = 1.0;
        vTexCoord.y = 0.0;
        EmitVertex();
        EndPrimitive();
		// 0 2 3 
		gl_Position = modelViewProjectionMatrix * ( vPosition[i] );
        vTexCoord.x = 0.5;
        vTexCoord.y = 0.5;
        EmitVertex();

        gl_Position = modelViewProjectionMatrix * (vPosition[i] + vec4(r/2.0,-rt*r,0.0,0.0));
        vTexCoord.x = 1.0;
        vTexCoord.y = 0.0;
        EmitVertex();

        gl_Position = modelViewProjectionMatrix * (vPosition[i] + vec4(r,0.0,0.0,0.0));
        vTexCoord.x = 0.0;
        vTexCoord.y = 0.0;
        EmitVertex();
        EndPrimitive();
		
		//0 3 4
		gl_Position = modelViewProjectionMatrix * ( vPosition[i] );
        vTexCoord.x = 0.5;
        vTexCoord.y = 0.5;
        EmitVertex();

        gl_Position = modelViewProjectionMatrix * (vPosition[i] + vec4(r,0.0,0.0,0.0));
        vTexCoord.x = 0.0;
        vTexCoord.y = 0.0;
        EmitVertex();

        gl_Position = modelViewProjectionMatrix * (vPosition[i] + vec4(r/2.0,rt*r,0.0,0.0));
        vTexCoord.x = 1.0;
        vTexCoord.y = 0.0;
        EmitVertex();
        EndPrimitive();
		//0 4 5
		gl_Position = modelViewProjectionMatrix * ( vPosition[i] );
        vTexCoord.x = 0.5;
        vTexCoord.y = 0.5;
        EmitVertex();

        gl_Position = modelViewProjectionMatrix * (vPosition[i] + vec4(r/2.0,rt*r,0.0,0.0));
        vTexCoord.x = 1.0;
        vTexCoord.y = 0.0;
        EmitVertex();

        gl_Position = modelViewProjectionMatrix * (vPosition[i] + vec4(-r/2.0,rt*r,0.0,0.0));
        vTexCoord.x = 0.0;
        vTexCoord.y = 0.0;
        EmitVertex();
        EndPrimitive();
		
		//0 5 6
		gl_Position = modelViewProjectionMatrix * ( vPosition[i] );
        vTexCoord.x = 0.5;
        vTexCoord.y = 0.5;
        EmitVertex();

        gl_Position = modelViewProjectionMatrix * (vPosition[i] + vec4(-r/2.0,rt*r,0.0,0.0));
        vTexCoord.x = 0.0;
        vTexCoord.y = 0.0;
        EmitVertex();

        gl_Position = modelViewProjectionMatrix * (vPosition[i] + vec4(-r/1.0,0.0,0.0,0.0));
        vTexCoord.x = 1.0;
        vTexCoord.y = 0.0;
        EmitVertex();
        EndPrimitive();
		//0 6 1
		gl_Position = modelViewProjectionMatrix * ( vPosition[i] );
        vTexCoord.x = 0.5;
        vTexCoord.y = 0.5;
        EmitVertex();

        gl_Position = modelViewProjectionMatrix * (vPosition[i] + vec4(-r/1.0,0.0,0.0,0.0));
        vTexCoord.x = 1.0;
        vTexCoord.y = 0.0;
        EmitVertex();

        gl_Position = modelViewProjectionMatrix * (vPosition[i] + vec4(-r/2.0,-rt*r,0.0,0.0));
        vTexCoord.x = 0.0;
        vTexCoord.y = 0.0;
        EmitVertex();
        EndPrimitive();

    }
}
