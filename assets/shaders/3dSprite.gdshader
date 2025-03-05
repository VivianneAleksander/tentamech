shader_type spatial;
render_mode unshaded;
render_mode cull_disabled;
uniform sampler2D albedo_texture : source_color;

void fragment() {
	if (texture(albedo_texture, UV).a < 0.01f)
	{
		discard;
	}
	ALBEDO = texture(albedo_texture, UV).rgb;
}