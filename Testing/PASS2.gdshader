shader_type spatial;
render_mode unshaded,cull_front,ensure_correct_normals;
void vertex(){
	VERTEX+=normalize(VERTEX)*0.025;
	
	
	
}
void fragment(){
	
	ALBEDO=vec3(0.);
	
}