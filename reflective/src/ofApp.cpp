#include "ofApp.h"
float r = 100;

struct Cube {
	int x;
	int y;
	int z;
};


struct Hex {
	int col;
	int row;
};
struct Point {
	float x;
	float y;
};

Hex cube_to_hex(Cube cube) {
	Hex result;
	result.col = cube.x;
	result.row = cube.z;
	return result;
}

Point oddq_offset_to_pixel(Hex hex) {

	float x = r*3.0 / 2.0*(float)hex.col;
	float y = r*sqrt(3.0)*((float)hex.row + .5*(float)(hex.col & 1));
	Point result;
	result.x = x;
	result.y = y;
	return result;
}
Cube cube_round(Cube cube) {
	int rx = cube.x;
	int ry = cube.y;
	int rz = cube.z;

	int x_diff = abs(rx - cube.x);
	int y_diff = abs(ry - cube.y);
	int z_diff = abs(rz - cube.z);

	if (x_diff > y_diff && x_diff > z_diff) {
		rx = -ry - rz;
	}
	else if (y_diff > z_diff) {
		ry = -rx - rz;

	}
	else {
		rz = -rx - ry;
	}
	Cube result;
	result.x = rx;
	result.y = ry;
	result.z = rz;
	return result;
}
Hex cube_to_oddq(Cube cube) {
	int col = cube.x;
	int row = cube.z + (cube.x - (cube.x & 1)) / 2;
	Hex result;
	result.col = col;
	result.row = row;
	return result;

}

Cube oddq_to_cube(Hex hex) {
	int x = hex.col;
	int z = hex.row - (hex.col - (hex.col & 1)) / 2;
	int y = -x - z;
	Cube result;
	result.x = x;
	result.y = y;
	result.z = z;
	return result;
}
//--------------------------------------------------------------
void ofApp::setup(){
	width = ofGetWindowWidth();
	height = ofGetWindowHeight();

	img.loadImage("fish.jpg");
	reflect.setGeometryInputType(GL_POINTS);
	reflect.setGeometryOutputType(GL_LINE_STRIP);
	reflect.setGeometryOutputCount(6);
	reflect.load("reflect.vert", "reflect.frag", "reflect.geom");

	shader.setGeometryInputType(GL_POINTS);
	shader.setGeometryOutputType(GL_TRIANGLE_STRIP);
	shader.setGeometryOutputCount(18);
	shader.load("render.vert", "render.frag", "render.geom");
	int sizing = (int) r;
	canvas.allocate(sizing, floor(sqrt(3) * sizing), GL_RGBA);
	canvasping.allocate(sizing, floor(sqrt(3) * sizing), GL_RGBA);

	canvas.begin();
	ofClear(155.0, 155.0, 155.0, 255);
	canvas.end();

	canvasping.begin();
	ofClear(0.0, 255.0, 255.0, 255.0);
	canvasping.end();

	mesh.setMode(OF_PRIMITIVE_POINTS);
	//TO DO: Geometry shader to turn mesh points into hexagons
	for (float x = 0; x < width+r; x += r*3) {
		for (float y = 0; y < height+r*2; y += r*sqrt(3)) {
			mesh.addVertex(ofVec3f((float)x, (float)y));
			mesh.addVertex(ofVec3f(x + r*1.5, y - sqrt(3)*r/2));

		}

	}

}

//--------------------------------------------------------------
void ofApp::update(){

}

//--------------------------------------------------------------
void ofApp::draw(){
	glLineWidth(15.00);
	ofDisableArbTex();
	shader.begin();
	shader.setUniformTexture("txture", canvas.getTexture(), 0);
	shader.setUniform2f("screen", canvas.getWidth(), canvas.getHeight());
	shader.setUniform1f("r", r);
	mesh.draw();
	shader.end();
	canvas.draw(0, 0);
	
	ofDrawCircle(px, py, 1);
	mesh.draw();
}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){

}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){

}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y ){

}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button) {
	float nx = (float)x;
	float ny = (float)y;
	float q = (2.0 / 3.0 * nx) / r;
	float z = (-1.0 / 3.0 * nx + sqrt(3.0) / 3.0*ny)/r;
	Cube cube;
	cube.x = (int)round(q);
	cube.y = (int)round(-q - z);
	cube.z = (int)round(z);

	Hex offset = cube_to_oddq(cube_round(cube));
	Point pt = oddq_offset_to_pixel(offset);


	Point hexPos;
	hexPos.x = pt.x;
	hexPos.y = pt.y;

	//Draw?
	ofMesh _mesh;
	_mesh.setMode(OF_PRIMITIVE_POINTS);
	_mesh.addVertex(ofVec3f(px, py));
	_mesh.addVertex(ofVec3f(nx, ny));

	
	canvas.begin();
	reflect.begin();
	reflect.setUniform2f("hexpos", (float)pt.x, (float)pt.y);
	reflect.setUniform2f("pmouse", px, py);
	reflect.setUniform2f("cmouse", nx, ny);
	reflect.setUniform1f("r", r);
	reflect.setUniform2f("canvas", canvasping.getWidth(),  canvasping.getHeight());
	reflect.setUniform2f("screen", width, height);
	ofSetLineWidth(15.0);
	_mesh.draw();
	reflect.end();
	canvas.end();


	canvasping.begin();
	canvas.draw(0,0);
	canvasping.end();
	//Continue drawing....
	//If done in shader, might be easier, bc shader has everything scaled from 0 to 1 already...




	px = nx;
	py = ny;
	printf("Coords: %f, %f \n", px, py);

}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){
	px = (float)x;
	py = (float)y;
	if (button == 1) {
		canvas.begin();
		ofClear(155, 155, 155, 255);
		canvas.end();
	}

}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseEntered(int x, int y){

}

//--------------------------------------------------------------
void ofApp::mouseExited(int x, int y){

}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){

}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){ 

}
