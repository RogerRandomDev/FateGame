shader_type spatial;
render_mode unshaded,cull_disabled;
uniform sampler2D particleImage:filter_nearest;
uniform vec3 particleColor:source_color;
void fragment() {
	ALBEDO=particleColor;
	ALPHA=texture(particleImage,UV).a;
}
