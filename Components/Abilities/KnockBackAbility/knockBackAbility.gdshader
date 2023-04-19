shader_type spatial;
render_mode unshaded,cull_disabled;
//level of distortion caused by ripples
uniform float rippleStrength;
//how far the ripple has moved from the center
uniform float rippleProgress=0.;


uniform sampler2D SCREEN_TEXTURE:hint_screen_texture;

void fragment() {
	
	//ALBEDO.rgb=texture(SCREEN_TEXTURE,SCREEN_UV).rgb;
	vec2 SIZE=vec2(textureSize(SCREEN_TEXTURE,2));
	vec2 rippleDir=vec2(NORMAL.x,-NORMAL.y);
	ALBEDO=texture(SCREEN_TEXTURE,SCREEN_UV+rippleDir/SIZE*4.*sin(rippleProgress*PI)).rgb;
	float rippleDist=distance(NORMAL,vec3(0.,0.,1.));
	ALPHA=float(rippleDist>=rippleProgress&&rippleDist<rippleProgress+rippleStrength);
}
