shader_type spatial;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float outline_width = 2.0;

void fragment() {
	vec4 screen_texture = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec2 pixel_size = 1.0 / VIEWPORT_SIZE;
	int i_outline_width = int(outline_width);

	ALBEDO = screen_texture.rgb;

	for(int y = -1 * i_outline_width; y <= 1 * i_outline_width; y++)
	for(int x = -1 * i_outline_width; x <= 1 * i_outline_width; x++){
		vec4 tex = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(float(x), float(y)) * pixel_size);
		vec2 uv_adjusted = vec2(SCREEN_UV.x * float(x) * pixel_size.x, SCREEN_UV.y * float(y) * pixel_size.y);

		if(tex.a == 0.0 &&
		uv_adjusted.x < 1.0 && uv_adjusted.x > 0.0 &&
		uv_adjusted.y < 1.0 && uv_adjusted.y > 0.0){
			ALBEDO = outline_color.rgb;
			ALPHA = 1.0;
		}
	}
}