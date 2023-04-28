shader_type spatial;
void fragment(){
	ALBEDO=vec3(1.);
	
}

void light(){
	float a=(ATTENUATION<0.75?(-0.75+abs(1.5-distance(sin(FRAGCOORD.x*20.),cos(FRAGCOORD.y*20.)))):1.);
	DIFFUSE_LIGHT=vec3(a)*LIGHT_COLOR;
}