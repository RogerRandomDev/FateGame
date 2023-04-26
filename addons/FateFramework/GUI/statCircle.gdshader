shader_type canvas_item;

uniform vec3 backColor:source_color;
uniform vec3 valueColor:source_color;
uniform vec3 lastValueColor:source_color=vec3(1.);

uniform int maxValue=100;
uniform int value=50;
uniform int lastValue=50;

uniform float circleThickness=0.25;

void fragment() {
	float dist=distance(UV-vec2(0.5),vec2(0.));
	float angle=(float(value)/float(maxValue))*PI*2.;
	float lastAngle=(float(lastValue)/float(maxValue))*PI*2.;
	float curAngle=atan(UV.x-0.5,UV.y-0.5)+PI;
	COLOR.rgba=vec4(
		angle<curAngle?(lastAngle<curAngle?backColor:lastValueColor):valueColor,
		float(dist<0.49&&dist>circleThickness)
		);
}
