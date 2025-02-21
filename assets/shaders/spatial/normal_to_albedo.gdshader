shader_type spatial;
render_mode unshaded, cull_back;

uniform vec3 color_shift;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {

	ALBEDO = (INV_VIEW_MATRIX * vec4(NORMAL, 0.0)).rgb + color_shift;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
