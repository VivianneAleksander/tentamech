// NOTE: Shader automatically converted from Godot Engine 4.3.stable's CanvasItemMaterial.

shader_type canvas_item;
render_mode blend_mix;

uniform float shape = 10.0;
uniform float scale = 1.0;
uniform float speed = 1.0;
uniform float offset = 0.0;

void vertex(){
	float x = shape * sin((TIME + offset) * speed);
	float y = sin(2.0 * (TIME + offset) * speed);
	VERTEX += scale * vec2(x, y);
}
