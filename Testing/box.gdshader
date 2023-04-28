shader_type spatial;
uniform sampler2D TEX;

void fragment() {
	ALBEDO=texture(TEX,UV.yx).rgb;
}

void light(){
	float a=(ATTENUATION<0.75?(-0.75+abs(1.5-distance(sin(FRAGCOORD.x*20.),cos(FRAGCOORD.y*20.)))):1.25-ATTENUATION);
	DIFFUSE_LIGHT=vec3(a);
}