shader_type canvas_item;
render_mode blend_mix;

uniform sampler2D noise;
uniform sampler2D color;
uniform float speed = 1.0;
uniform float scale = 1.0;
uniform vec2 direction = vec2(1.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float sample = texture(noise, fract((UV * scale) + (normalize(direction) * TIME * speed))).x;
	float a = texture(color, vec2(sample)).x;
	COLOR.a *= a;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
