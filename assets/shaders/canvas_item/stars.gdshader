shader_type canvas_item;
render_mode blend_mix;

uniform float shelf = 0.5;
uniform sampler2D noise1 : source_color;
uniform float speed1 = 1.0;
uniform float scale1 = 1.0;
uniform vec2 dir1 = vec2(1.0);
uniform float speed2 = 1.0;
uniform float scale2 = 1.0;
uniform vec2 dir2 = vec2(-1.0);

float rand(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

void fragment() {
	vec2 uv_mod1 = fract(UV * scale1 + vec2(TIME * speed1) * normalize(dir1));
	float sample = texture(noise1, uv_mod1).x;

	vec2 uv_mod2 = fract(UV + vec2(TIME * speed2) * normalize(dir2));
	float rand_val = rand(uv_mod2) * scale2;

	if (rand_val <= shelf)
	{
		discard;
	}
	COLOR.a *= sample;
}