//THIS SHADER MUST BE APPLIED TO A QUAD (MeshInstance) WITH A SIZE OF (2, 2)
//Extra Cull Margin on the quad should be turned up all the way!

shader_type spatial;
render_mode unshaded,depth_draw_always,depth_test_disabled;
uniform sampler2D SCREEN_TEXTURE:hint_screen_texture;
uniform sampler2D DEPTH_TEXTURE:hint_depth_texture;
uniform float outline_bias : hint_range(-10, 10) = 0;

void vertex() {
	POSITION = vec4(VERTEX, 1.0);
}



void fragment() {
	ALBEDO = vec3(0.);
	
	vec2 screen_size = vec2(textureSize(SCREEN_TEXTURE, 0));
	
	float px = 0.5/screen_size.x;
	float py = 0.5/screen_size.y;
	
	//calculate outlines
	
	
	float d = texture(DEPTH_TEXTURE, SCREEN_UV).x;
	float du = texture(DEPTH_TEXTURE, SCREEN_UV+vec2(0.0, py)).x;
	float dd = texture(DEPTH_TEXTURE, SCREEN_UV+vec2(0.0, -py)).x;
	float dr = texture(DEPTH_TEXTURE, SCREEN_UV+vec2(px, 0.0)).x;
	float dl = texture(DEPTH_TEXTURE, SCREEN_UV+vec2(-px, 0.0)).x;
	float p = texture(SCREEN_TEXTURE, SCREEN_UV).x;
	float pu = texture(SCREEN_TEXTURE, SCREEN_UV+vec2(0.0, py)).x;
	float pd = texture(SCREEN_TEXTURE, SCREEN_UV+vec2(0.0, -py)).x;
	float pr = texture(SCREEN_TEXTURE, SCREEN_UV+vec2(px, 0.0)).x;
	float pl = texture(SCREEN_TEXTURE, SCREEN_UV+vec2(-px, 0.0)).x;
	
	ALPHA=round(
		(0.0 + abs(abs(abs(d)-abs(du)) - abs(abs(d)-abs(dd))) + abs(abs(abs(d)-abs(dl)) - abs(abs(d)-abs(dr))))*1200.+ outline_bias);
	
}

//Written by Warren Jennings