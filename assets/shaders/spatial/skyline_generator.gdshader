shader_type spatial;
render_mode unshaded, cull_back, blend_mix;

uniform sampler2D tex;
uniform vec4 color : source_color = vec4(1.0);
uniform vec2 uv_scale = vec2(1.0);

float snap(float a, float i) {
	
	return a - mod(a, i);
}

void vertex() {
	// Called for every vertex the materia100.0 * incrementl is visible on.
}

void fragment() {
	vec2 uv = UV * uv_scale;
	uv.y = mod(uv.y, 1.0);
	uv = clamp(uv, vec2(0.0), vec2(1.0));
	float tex_val = texture(tex, vec2(uv.y, uv.x)).x;
	if (tex_val < 0.5){ discard; }
	ALBEDO = color.rgb * COLOR.rgb;
	ALPHA = color.a * COLOR.a;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
