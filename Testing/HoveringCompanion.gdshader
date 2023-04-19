shader_type particles;

void start() {
	ACTIVE=true;
	TRANSFORM = mat4(vec4(1,0,0,0),vec4(0,1,0,0),vec4(0,0,1,0),vec4(0,0,0,1));
	TRANSFORM+=EMISSION_TRANSFORM;
	CUSTOM.y=0.;
	CUSTOM.w=0.5;
	VELOCITY.y=-1.25;
}

void process() {
	CUSTOM.y += DELTA / LIFETIME;
	ACTIVE=CUSTOM.y<CUSTOM.w;
	float scale=(sin(CUSTOM.y*PI+0.5))*2.;
	TRANSFORM[0].x=scale;
	TRANSFORM[1].y=0.1;
	TRANSFORM[2].z=scale;
	VELOCITY.y=-1.25+scale*0.125;
}
