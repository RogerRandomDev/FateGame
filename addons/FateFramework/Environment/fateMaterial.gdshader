shader_type spatial;
render_mode cull_disabled;
uniform sampler2D TEXTURE:filter_nearest;
uniform float scaleMult=1.;



void fragment(){
	ALBEDO=pow(texture(TEXTURE,UV).rgb,vec3(2.2));
}
global uniform float DOTRATE;


// Per-vertex input/output
varying vec2 shadowCoords;

void vertex() {
	// Transform the vertex position to object space
	vec3 objPos = VERTEX;
	
	// Calculate the 2D coordinates of the vertex in object space
//	shadowCoords = objPos.xy*NORMAL.z+objPos.xz*NORMAL.y+objPos.zy*NORMAL.x;
	shadowCoords = vec2(dot(TANGENT, objPos), dot(BINORMAL, objPos));
	// Output the vertex position in world space
	
}

void light() {
	// Calculate the shadow intensity based on the dot product of the shadow coordinates
	// and the DOT_RATE parameter
	float shadowIntensity = abs(sin(shadowCoords.x * DOTRATE*scaleMult) * cos(shadowCoords.y * DOTRATE*scaleMult))*(1.-ATTENUATION);
	shadowIntensity=clamp(float(shadowIntensity>0.5)*2.+0.9*(1.-ATTENUATION),0.,1.);
	// Apply the shadow intensity as a diffuse color
	DIFFUSE_LIGHT = vec3(-shadowIntensity);
}