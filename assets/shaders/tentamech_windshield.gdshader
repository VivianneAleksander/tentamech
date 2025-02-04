shader_type spatial;
render_mode blend_mix, depth_draw_always, cull_back, shadows_disabled, diffuse_burley, specular_schlick_ggx;

uniform vec4 albedo : source_color;
uniform float specular : hint_range(0.0, 1.0);
uniform float metallic : hint_range(0.0, 1.0);
uniform float roughness : hint_range(0.0, 1.0);

uniform sampler2D texture_normal : hint_roughness_normal,filter_linear_mipmap,repeat_enable;
uniform float normal_scale : hint_range(-16, 16);

uniform sampler2D light_gradient;
uniform sampler2D fresnel_gradient;

float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 base_uv = UV;

	ALBEDO = albedo.rgb;
	ALPHA = albedo.a;

	SPECULAR = specular;
	METALLIC = metallic;
	ROUGHNESS = roughness;

	NORMAL_MAP = texture(texture_normal, base_uv).rgb;
	NORMAL_MAP_DEPTH = normal_scale;
}

void light() {
	float fres = fresnel(0.1, NORMAL, VIEW);
	vec3 nufres = texture(fresnel_gradient, vec2(fres, 0.0)).rgb;

	float dotproduct = clamp(dot(NORMAL, LIGHT), -0.9, 0.9);
	float sample = clamp((dotproduct + 1.0) * ATTENUATION / 2.1, 0.05, 0.95);
	vec3 shaded = texture(light_gradient, vec2(sample, 0.0)).rgb;
	vec3 result = shaded + nufres;
	DIFFUSE_LIGHT = step(1.0, clamp(DIFFUSE_LIGHT / 100.0 + (result * LIGHT_COLOR), 0.0, 1.0)) * 100.0;
}
