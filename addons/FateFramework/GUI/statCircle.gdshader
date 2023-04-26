shader_type canvas_item;

uniform vec3 backColor:source_color;
uniform vec3 valueColor:source_color;
uniform vec3 lastValueColor:source_color=vec3(1.);

uniform int maxValue=100;
uniform int value=50;
uniform int lastValue=50;
uniform float lengthOfLine:hint_range(0.,1.)=0.75;
uniform float lineAccountsPercentage:hint_range(0.,1.)=0.5;

const float circleThickness=32.;

uniform vec2 halfSize=vec2(48.,48.);
varying vec2 corner;
void vertex(){
	if(VERTEX_ID==0){corner.xy=VERTEX.xy;}
	corner.x=max(corner.x,VERTEX.x);
	corner.y=max(corner.y,VERTEX.y);
}
void fragment() {
	vec2 trueUV=(FRAGCOORD.xy-corner.xy);
	float dist=distance(SCREEN_UV.xy-halfSize+corner.xy,vec2(0.));
	float angle=((float(value)-(float(maxValue)*lineAccountsPercentage))/(float(maxValue)))*PI*2. /(1.-lineAccountsPercentage);
	float lastAngle=((float(lastValue)-(float(maxValue)*lineAccountsPercentage))/float(maxValue))*PI*2. /(1.-lineAccountsPercentage);
	float curAngle=atan(SCREEN_UV.x-halfSize.x+corner.x,SCREEN_UV.y-halfSize.y+corner.y)+PI;
	bool straightLine=SCREEN_UV.y+corner.y<halfSize.y-circleThickness&&UV.x>1.-lengthOfLine;
	float straightValue=((1.-(UV.x*lengthOfLine))*lineAccountsPercentage);
	float val=((float(value)-float(maxValue)*(lineAccountsPercentage))/float(maxValue));
	float lastVal=((float(lastValue)-(float(maxValue)*(lineAccountsPercentage)))/float(maxValue));
	COLOR.rgba=vec4(
		(straightLine?
			(straightValue<val?valueColor:(straightValue<lastVal?lastValueColor:backColor)):
			(angle<curAngle?(lastAngle<curAngle?backColor:lastValueColor):valueColor)),
		float(dist<halfSize.x*1.&&dist>circleThickness||straightLine)
		);
}
