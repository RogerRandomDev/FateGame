shader_type spatial;
render_mode unshaded,cull_front,vertex_lighting;
void vertex(){
	VERTEX+=normalize(VERTEX)*0.05;
}
void fragment(){
	ALBEDO=vec3(0.);
}