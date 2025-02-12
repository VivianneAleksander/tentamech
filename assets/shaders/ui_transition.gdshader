shader_type canvas_item;

uniform float right_slide = 0.5;
uniform float left_slide = 0.0;
uniform float angle = 0.5;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float right = floor((UV.y + right_slide) - (UV.x * angle));
	float left = 1.0- floor((UV.y + left_slide) - (UV.x * angle));
	COLOR.a = right * left;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
