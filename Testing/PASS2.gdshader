shader_type spatial;
render_mode unshaded,cull_front,ensure_correct_normals;
void vertex(){
	VERTEX+=NORMAL*0.025;
	NORMAL*=-1.;
	
	
}
void fragment(){
	
	ALBEDO=vec3(0.);
	
}