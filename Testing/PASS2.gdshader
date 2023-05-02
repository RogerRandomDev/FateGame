shader_type spatial;
render_mode unshaded,cull_front,vertex_lighting;
void vertex(){
	
	VERTEX+=NORMAL*0.025;
}
void fragment(){
	
	ALBEDO=vec3(0.);
	
}