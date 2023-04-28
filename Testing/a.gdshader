shader_type spatial;
void fragment(){
	ALBEDO=vec3(1.);
	
}

void light(){
	float a=(float(distance(sin(FRAGCOORD.x*150.),cos(FRAGCOORD.y*150.))*(1.-ATTENUATION)));
	DIFFUSE_LIGHT=vec3(-a);
	
}