shader_type spatial;
render_mode diffuse_toon, specular_toon, cull_back, fog_disabled;

uniform sampler2D skyscraper_tex;
uniform sampler2D skyscraper_color : source_color;

uniform float metallic = 0.0;
uniform float roughness = 1.0;

uniform float rim = 0.0;
uniform float rim_tint = 1.0;

uniform float clearcoat = 0.0;
uniform float clearcoat_gloss = 1.0;

uniform float anisotropy = 0.0;

uniform float emission = 0.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 sample = texture(skyscraper_tex, UV).rgb;
	float value = max(sample.x, sample.y);
	value = max(value, sample.z);
	vec3 color = texture(skyscraper_color, vec2(value, 0.0)).rgb;
	ALBEDO = color;
	EMISSION = color * emission;
	METALLIC = color.r * metallic;
	ROUGHNESS = 1.0 - color.r * roughness;
	RIM = rim;
	RIM_TINT = rim_tint;
	CLEARCOAT = clearcoat;
	CLEARCOAT_ROUGHNESS = clearcoat_gloss;
	ANISOTROPY = anisotropy;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
