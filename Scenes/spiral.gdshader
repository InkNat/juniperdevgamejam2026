shader_type canvas_item;

uniform float ring_amount = 3.;
uniform int line_amount = 1;
uniform vec2 offset;
uniform vec2 scale = vec2(1,1);


uniform vec3 color1 : source_color = vec3(1);
uniform vec3 color2 : source_color = vec3(0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 curr_uv = UV;
	curr_uv += offset;
	curr_uv *= scale;
	
	vec2 uv_offset = vec2(0.5 * scale);
	float angle = atan(curr_uv.y - uv_offset.x, curr_uv.x - uv_offset.y) + TIME;
	
	float curr_dist = distance(curr_uv, uv_offset);
	float curr_value = ceil(sin(curr_dist * (ring_amount * 10.) + angle * float(line_amount)));
	
	if (curr_value > 0.f) {
		COLOR.rgb = color1;
	}
	else {
		COLOR.rgb = color2;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
