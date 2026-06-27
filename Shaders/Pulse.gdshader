shader_type canvas_item;

uniform float time;

float easeOutSine(float x) {
  return 1.0 - pow((1.0-x),3);
}
void fragment() {
	vec2 center = vec2(0.5,0.5);
	float dist = distance(center,UV);
	float e = time;
	e = easeOutSine(e);
	e /= 2.0;
	if (dist < e || dist > e + 0.05-(e/10.0) ) {
		COLOR.a = 0.0;
	}
}