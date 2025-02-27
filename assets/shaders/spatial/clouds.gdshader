shader_type spatial;
render_mode blend_mix, unshaded, cull_back, fog_disabled, depth_draw_always;

uniform vec4 color : source_color = vec4(1.0);
uniform float speed = 1.0;
uniform vec2 direction = vec2(1.0, 0.0);
uniform sampler2D noise;
uniform float shelf : hint_range(0.0, 1.0, 0.01) = 0.5;
uniform vec2 uv_scale = vec2(1.0);
uniform float depth_scale = 1.0;


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float sample = texture(noise, UV * uv_scale + (normalize(direction) * TIME * speed)).r;
	if (sample >= shelf){ discard; }

	float depth = FRAGCOORD.z * depth_scale * 1000.0;
	ALBEDO = color.rgb * COLOR.rgb;
	ALPHA = color.a * COLOR.a * depth;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
