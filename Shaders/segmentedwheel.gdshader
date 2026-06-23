shader_type canvas_item;
uniform sampler2D colorSampler : filter_nearest;
uniform vec4 separatorColor : source_color = vec4(0);
uniform float angle_offset = 0;
uniform int separatorCount = 4;
uniform float separatorLength = 0.02f;
uniform float minLength = 0.45f;
uniform float maxLength = 0.5f;
void fragment() {
	float segmentLength = 1.0f/float(separatorCount);
	float angle = (atan(UV.x - 0.5f, UV.y - 0.5f)/(PI*2.0f)) + angle_offset;
	angle = mod(angle, 1.0f);
	COLOR.a = 0.0;
	
	
	float uvLength = length(UV-vec2(0.5f,0.5f));
	if (uvLength > minLength && uvLength < maxLength) {
		float index = floor(angle * float(separatorCount));
		ivec2 texture_size = textureSize(colorSampler,0);
		float texture_area = float(texture_size.x * texture_size.y);
		
		index = mod(index, texture_area);
		
		float coord_x = mod(float(index), float(texture_size.x))/float(texture_size.x);
		float coord_y = index/float(texture_size.x);
		
		COLOR = texture(colorSampler, vec2(coord_x, coord_y));
		
		
		if (mod(angle+(separatorLength/2.0f),segmentLength) < separatorLength)
			COLOR = separatorColor;
	}
}
