shader_type spatial;
render_mode unshaded;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = vec3(1,1,1);
	ALPHA = (sin(TIME*5.0f)+3.0f)/6.0f;
}
