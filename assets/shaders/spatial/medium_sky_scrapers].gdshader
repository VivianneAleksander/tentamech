shader_type spatial;
render_mode unshaded, cull_back;

uniform sampler2D skyscraper_tex;
uniform sampler2D skyscraper_color : source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 sample = texture(skyscraper_tex, UV).rgb;
	float value = max(sample.x, sample.y);
	value = max(value, sample.z);
	vec3 color = texture(skyscraper_color, vec2(value, 0.0)).rgb;
	ALBEDO = color;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
