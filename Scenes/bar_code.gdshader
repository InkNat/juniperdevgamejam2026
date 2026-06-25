shader_type canvas_item;

uniform float seed = 0;
uniform int resolution = 0;

void vertex() {
	// Called for every vertex the material is visible on.
}
float random (vec2 uv) {
    return fract(sin(dot(uv.xy*vec2(seed,seed),
        vec2(12.9898,78.233))) * 43758.5453123);
}

void fragment() {
	float e = floor(UV.x*float(resolution));
	if (random(vec2(e,0)) > 0.5f) {
		COLOR.rgb = vec3(0);
	}
}

