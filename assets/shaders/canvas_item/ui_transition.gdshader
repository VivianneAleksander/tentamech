shader_type canvas_item;

uniform float right_slide = 0.5;
uniform float left_slide = 0.0;
uniform float angle_right = 0.0;
uniform float angle_left = 0.0;

void vertex() {
	// Called for every vertex the material is visible on.
}
void fragment() {
	vec2 m_right = vec2(sin(-angle_right), cos(-angle_right));
	vec2 rotated_coords_right = vec2(
		((UV.x + -right_slide) * m_right.y) - UV.y * m_right.x,
		((UV.x + -right_slide) * m_right.x) + UV.y * m_right.y
	);
	vec2 m_left = vec2(sin(-angle_left), cos(-angle_left));
	vec2 rotated_coords_left = vec2(
		((UV.x + -left_slide) * m_left.y) - UV.y * m_left.x,
		((UV.x + -left_slide) * m_left.x) + UV.y * m_left.y
	);

	float right = clamp(floor(rotated_coords_right.y - rotated_coords_right.x), 0, 1);
	float left = 1.0 - clamp(floor(rotated_coords_left.y - rotated_coords_left.x), 0, 1);
	COLOR.a = right * left * COLOR.a;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
