shader_type canvas_item;
render_mode blend_mix;

uniform float speed = 1.0;

float rand(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

void fragment() {
	if (rand(UV) <= 0.997){
		discard;
	}
	float r = rand(UV / 20.0);
	float color = r * (0.85 * sin(TIME * speed * (r * 5.0) + 720.0 * r) + 0.95);
	COLOR.a *= color;
}