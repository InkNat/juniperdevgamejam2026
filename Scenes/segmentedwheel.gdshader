shader_type canvas_item;
uniform vec4 fillColor1 : source_color = vec4(0);
uniform vec4 fillColor2 : source_color = vec4(0);
uniform vec4 separatorColor : source_color = vec4(0);
uniform float fillness = 0.0f;
uniform int separatorCount = 4;
uniform float separatorLength = 0.02f;
uniform float minLength = 0.45f;
uniform float maxLength = 0.5f;
void fragment() {
	float segmentLength = 1.0f/float(separatorCount);
	float angle = (atan(UV.x - 0.5f, UV.y - 0.5f)/(PI*2.0f)) +0.5f;
	COLOR.a = 0.0;
	
	
	float uvLength = length(UV-vec2(0.5f,0.5f));
	if (uvLength > minLength && uvLength < maxLength) {
		if (angle > 0.0f && angle < fillness) {
			COLOR = fillColor2;
			if (ceil(angle/segmentLength)*segmentLength <= fillness)
				COLOR = fillColor1;
		}
		if (mod(angle+(separatorLength/2.0f),segmentLength) < separatorLength)
			COLOR = separatorColor;
	}
}
