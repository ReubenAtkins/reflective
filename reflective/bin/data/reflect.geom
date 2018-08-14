#version 150
#define TAU 6.2831853071
layout (points) in;
layout (line_strip) out;
layout (max_vertices = 6) out;

uniform mat4 modelViewProjectionMatrix;
uniform float r;
uniform vec2 screen;
uniform vec2 canvas;
uniform vec2 pmouse;
uniform vec2 cmouse;

in vec4 vPosition[];

out vec2 vTexCoord;

vec2 cube_to_hex(vec3 cube) {
	vec2 result;
	//col = x, row = 'z' or i guess y
	result.x = cube.x;
	result.y = cube.z;
	return result;
}
vec2 oddq_offset_to_pixel(vec2 hex) {
	//x = col
	float x = r*3.0/2.0*hex.x;
	//y = row
	float y = r*sqrt(3.0)*(hex.y+.5*mod(floor(hex.x), 2.0));
	vec2 result;
	result.x = x;
	result.y = y;
	return result;
}
vec3 cube_round(vec3 cube) {
	int rx = int(round(cube.x));
	int ry = int(round(cube.y));
	int rz = int(round(cube.z));
	
	int x_diff = abs(rx-int(cube.x));
	int y_diff = abs(ry-int(cube.y));
	int z_diff = abs(rz-int(cube.z));
	
	
	if (x_diff > y_diff && x_diff > z_diff) {
		rx = -ry - rz;
	}
	else if (y_diff > z_diff) {
		ry = -rx - rz;

	}
	else {
		rz = -rx - ry;
	}
	vec3 result;
	result.x = float(rx);
	result.y = float(ry);
	result.z = float(rz);
	return result;

}

vec2 cube_to_oddq(vec3 cube) {
	int col = int(cube.x);
	int row = int(cube.z+(cube.x-(mod(cube.x, 2.0)))/2.0);
	vec2 result;
	result.x = float(col);
	result.y = float(row);
	return result;
}
vec3 oddq_to_cube(vec2 hex) {
	float x = hex.x;
	float z = hex.y-(hex.x-(mod(hex.x, 2.0)))/2.0;
	float y = -x-z;
	vec3 result;
	result.x = x;
	result.y = y;
	result.z = z;
	return result;

}
void main(void){
	vec4 p = vec4(pmouse.xy, 1.0, 1.0);
	vec4 c = vec4(cmouse.xy, 1.0, 1.0);
	//TODO: End primitive for when in new quadrant???

	
	
	for(int i = 0; i < 6; i++) {
		vec4 curpos = mix(p, c, float(i)/5.0);
			
		float q = (2.0/3.0*curpos.x)/r;
		float z = (-1.0/3.0*curpos.x+sqrt(3.0)/3.0*curpos.y)/r;
		vec3 cube;
		cube.x = round(q);
		cube.y = round(-q-z);
		cube.z = (round(z));
		vec2 offset = cube_to_oddq(cube_round(cube));
		vec2 point = oddq_offset_to_pixel(offset);
		
		//point is point of hexagon 
		//translate to 0, 0
		curpos.x -= point.x;
		curpos.y -= point.y;
		float magx = distance(curpos.x, 0.0);
		float magy = distance(curpos.y, 0.0);
		float mag = distance(curpos.xy, vec2(0.0, 0.0));
		//then get angle & quadrant?
		float rads = atan(curpos.y, curpos.x);
		int quadrant = int(floor((rads * 180.0/(TAU/2.0))/60.0));
		int flip = 0;
		if (quadrant < 0) {
		
			quadrant = abs(quadrant-1);
			if (mod(quadrant, 2) == 1) {
				flip = 1;
			
			}
			
		}else {
		quadrant = -1*(quadrant-1);
		if (mod(abs(quadrant), 2) == 1) {
			flip = 1;
			}
		}
		
		
		float newx = cos(rads+float(quadrant)*TAU/6.0)*mag;
		float newy = sin(rads+float(quadrant)*TAU/6.0)*mag;
		newx += r/2.0;
		newx /= r;
		newx = 1.0-newx;
		//scale 0 to root(3)/2 * r to .5 to 0
		newy /= r*sqrt(3.0)/2.0 ;
		newy = 1.0-newy;
		//newy = 1.0-(newy*(1.0/(sqrt(3.0)/2.0 * r)));
		newy/=2.0;
		if(flip == 0) {
		newx = 1.0-newx;
		
		
		}
		//Now newx and newy are from 0 to 1 properly scaled hopefully

		

		gl_Position = modelViewProjectionMatrix*vec4(newx*canvas.x, newy*canvas.y, 1.0, 1.0);
		EmitVertex();
	
	}


	EndPrimitive();

	}


	