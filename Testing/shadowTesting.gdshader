// NOTE: Shader automatically converted from Godot Engine 4.0.1.stable's StandardMaterial3D.
shader_type spatial;
render_mode shadow_to_opacity,blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;
uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color,filter_linear_mipmap,repeat_enable;
uniform float point_size : hint_range(0,128);
uniform float roughness : hint_range(0,1);
uniform sampler2D texture_metallic : hint_default_white,filter_linear_mipmap,repeat_enable;
uniform vec4 metallic_texture_channel;
uniform sampler2D texture_roughness : hint_roughness_r,filter_linear_mipmap,repeat_enable;
uniform float specular;
uniform float metallic;
varying vec3 uv1_triplanar_pos;
uniform float uv1_blend_sharpness;
varying vec3 uv1_power_normal;
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform sampler2D TEXTURE;
uniform float scaleMult=1.;
uniform vec2 scale=vec2(1.0);
global uniform float DOTRATE;

// Per-vertex input/output
varying vec2 shadowCoords;

void vertex() {
	TANGENT = vec3(0.0,0.0,-1.0) * abs(NORMAL.x);
	TANGENT+= vec3(1.0,0.0,0.0) * abs(NORMAL.y);
	TANGENT+= vec3(1.0,0.0,0.0) * abs(NORMAL.z);
	TANGENT = normalize(TANGENT);
	BINORMAL = vec3(0.0,1.0,0.0) * abs(NORMAL.x);
	BINORMAL+= vec3(0.0,0.0,-1.0) * abs(NORMAL.y);
	BINORMAL+= vec3(0.0,1.0,0.0) * abs(NORMAL.z);
	BINORMAL = normalize(BINORMAL);
	uv1_power_normal=pow(abs(NORMAL),vec3(uv1_blend_sharpness));
	uv1_triplanar_pos = VERTEX * uv1_scale + uv1_offset;
	uv1_power_normal/=dot(uv1_power_normal,vec3(1.0));
	uv1_triplanar_pos *= vec3(1.0,-1.0, 1.0);
		// Transform the vertex position to object space
	vec3 objPos = VERTEX;
	
	// Calculate the 2D coordinates of the vertex in object space
//	shadowCoords = objPos.xy*NORMAL.z+objPos.xz*NORMAL.y+objPos.zy*NORMAL.x;
	shadowCoords = vec2(dot(TANGENT, objPos), dot(BINORMAL, objPos))*scale;
	// Output the vertex position in world space
	
}




vec4 triplanar_texture(sampler2D p_sampler,vec3 p_weights,vec3 p_triplanar_pos) {
	vec4 samp=vec4(0.0);
	samp+= texture(p_sampler,p_triplanar_pos.xy) * p_weights.z;
	samp+= texture(p_sampler,p_triplanar_pos.xz) * p_weights.y;
	samp+= texture(p_sampler,p_triplanar_pos.zy * vec2(-1.0,1.0)) * p_weights.x;
	return samp;
}








void fragment() {
	
	float shadowStrength=float(abs(
		sin(DOTRATE*(shadowCoords.x))*sin(DOTRATE*(shadowCoords.y))
	)>0.5);
	// unshaded lighting
	// add alpha b(0.5-ATTENUATION)ased on attenuation, which includes if we're in shadow, cap at our max opacity
	ALBEDO=vec3(-shadowStrength);
}
void light() {
	ALPHA=min(ALPHA,0.5-ATTENUATION);
}