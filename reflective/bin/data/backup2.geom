#version 150
#define TAU 6.2831853071
layout (points) in;
layout (line_strip) out;
layout (max_vertices = 6) out;

uniform mat4 modelViewProjectionMatrix;
uniform float r;
uniform vec2 pmouse;
uniform vec2 cmouse;
uniform vec2 screen;
uniform vec2 canvas;


in vec4 vPosition[];

out vec2 vTexCoord;

void main(void){
	float rt = sqrt(3.0)/2.0;
    
	vec4 pos = vPosition[0];
	
	
	for(float i = 0; i < 1; i+= 1.0/6.0) {
		float newx = smoothstep(pmouse.x, cmouse.x, i);
		float newy = smoothstep(pmouse.y, cmouse.y, i);
		newx -= pos.x;
		newy -= pos.y;
		newx/=r;
		newy/=r;
		//Should now be between 0 and 1
		float mag = distance(vec2(newx, newy), vec2(0.0, 0.0));

		float rads = atan(newy, newx);
		int angle = int(rads*180.00*TAU/2.0);
		int flip = int(mod(1+angle/60,2));
		int quadrant = int(angle/60);
		if (quadrant < 0 && rads < 0) {
			float addx = cos(abs(float(quadrant-2))*TAU/6.0+rads);
			float addy = sin(abs(float(quadrant-2))*TAU/6.0+rads);
			addx+=1.0;
			addx/=2.0;
			addy+=1.0;
			addy/=2.0;
			//now addx and addy are between 0 and 1
			//convert 0 and 1 to screen width and height in next step
			gl_Position = modelViewProjectionMatrix*(pos+vec4(addx*mag * screen.x, addy*mag * screen.y, 0.0, 0.0));
			vTexCoord.x = addx*mag;
			vTexCoord.y = addy*mag;
			if (flip == 1) {
				vTexCoord.x = 1.0-vTexCoord.x;
			}
			EmitVertex();
		} else {
			float addx = cos(abs(float(quadrant))*TAU/6.0+rads);
			float addy = sin(abs(float(quadrant))*TAU/6.0+rads);
			addx+=1.0;
			addx/=2.0;
			addy+=1.0;
			addy/=2.0;
			gl_Position = modelViewProjectionMatrix*(pos+vec4(addx*mag*screen.x, addy*mag*screen.y, 0.0, 0.0));
			vTexCoord.x = addx*mag;
			vTexCoord.y = addy*mag;
			if (flip == 1) {
				vTexCoord.x = 1.0-vTexCoord.x;
			}
			EmitVertex();
		
		}
		
		
	
	}
	EndPrimitive();
}

	