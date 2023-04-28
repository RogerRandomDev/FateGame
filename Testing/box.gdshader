shader_type spatial;
uniform sampler2D TEX;

void fragment() {
	ALBEDO=texture(TEX,UV.yx).rgb;
}

void light(){
	float a=(float(distance(sin(FRAGCOORD.x*150.),cos(FRAGCOORD.y*150.))*(1.-ATTENUATION)));
	DIFFUSE_LIGHT=vec3(-a);
}