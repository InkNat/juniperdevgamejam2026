shader_type canvas_item;

uniform sampler2D text : filter_nearest;
uniform vec2 second_offset = vec2(0,0.125);
uniform vec2 size = vec2(128.0);
uniform float speed = 0.2;
uniform vec4 background_color : source_color = vec4(0.0);
uniform vec4 text_color : source_color = vec4(1.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	
	vec2 diff = vec2(textureSize(text,0))/size;
	
	float time_mult = TIME*speed;
	bool result = 
		texture(text, vec2(mod(time_mult+(UV.x/diff.x),1),mod(time_mult+(UV.y/diff.y),1))).a > 0.0f || 
		texture(text, vec2(mod(second_offset.x-time_mult+(UV.x/diff.x),1),mod(second_offset.y-time_mult+(UV.y/diff.y),1))).a > 0.0f;
	if (result) {
		COLOR = text_color;
	}
	else {
		COLOR = background_color;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
