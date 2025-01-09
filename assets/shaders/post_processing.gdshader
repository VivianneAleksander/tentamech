shader_type spatial;
render_mode unshaded, fog_disabled;

uniform sampler2D depth_tex : source_color, hint_depth_texture, filter_nearest;

uniform float outline_thickness;
uniform vec3 outline_color : source_color = vec3(0);
uniform float step_threshold_max : hint_range(0.0, 1.0, 0.01) = 0.5;
uniform float step_threshold_min : hint_range(0.0, 1.0, 0.01) = 0.0;

float DepthVS(vec2 uv, mat4 inv_pro_mat){
	float depth = texture(depth_tex, uv).r;
	return 1. / (depth * inv_pro_mat[2].w + inv_pro_mat[3].w);
}

void vertex() {
	POSITION = vec4 (VERTEX.xy, 1.0, 1.0);
}

void fragment() {
	float thickness = outline_thickness * 0.001;
	float depth = DepthVS(SCREEN_UV, INV_PROJECTION_MATRIX);
	float border_r = DepthVS(SCREEN_UV + vec2(thickness, 0), INV_PROJECTION_MATRIX) - depth;
	float border_l = DepthVS(SCREEN_UV - vec2(thickness, 0), INV_PROJECTION_MATRIX) - depth;
	float border_u = DepthVS(SCREEN_UV + vec2(0, thickness), INV_PROJECTION_MATRIX) - depth;
	float border_d = DepthVS(SCREEN_UV - vec2(0, thickness), INV_PROJECTION_MATRIX) - depth;
	
	float outline = clamp(border_l + border_r + border_u + border_d, 0, 1);
	outline = smoothstep(step_threshold_min, step_threshold_max, outline);
	
	ALBEDO.rgb = outline * outline_color;
	ALPHA = outline;
	//ALBEDO = texture(depth_tex, UV).rgb;
}

