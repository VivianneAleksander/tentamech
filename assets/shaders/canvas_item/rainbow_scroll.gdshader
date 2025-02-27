shader_type canvas_item;

uniform float wiggle_radius = 1.0;
uniform float wiggle_speed = 1.0;
uniform float angle = 1.0;
uniform float speed = 1.0;
uniform sampler2D colors : source_color;

void vertex() {
	float wave = TIME * wiggle_speed;
	VERTEX += vec2(sin(wave), cos(wave)) * wiggle_radius;
}

void fragment() {
	vec2 uv_mod = vec2(fract(UV.x + (TIME * speed) - (UV.y * angle)), UV.y);
	vec4 color = texture(colors, uv_mod);
	float a = ceil(COLOR.a);
	COLOR = color;
	COLOR.a = a;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
