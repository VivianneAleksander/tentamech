shader_type spatial;
render_mode unshaded;

uniform float _columns = 3.0;
uniform float _rows = 5.0;
uniform float _wobble_speed = 1.0;
uniform sampler2D _color_gradient : source_color;

vec2 random(vec2 uv) {
	return vec2(fract(sin(dot(uv.xy,
		vec2(12.9898,78.233))) * 43758.5453123));
}

float worley(vec2 uv, float columns, float rows, float time) {
	
	vec2 index_uv = floor(vec2(uv.x * columns, uv.y * rows));
	vec2 fract_uv = fract(vec2(uv.x * columns, uv.y * rows));
	
	float minimum_dist = 1.0;  
	
	for (int y= -1; y <= 1; y++) {
		for (int x= -1; x <= 1; x++) {
			vec2 neighbor = vec2(float(x),float(y));
			vec2 point = random(index_uv + neighbor);
			float speed = 4.5;
			point = vec2( cos(time * point.x * speed), sin(time * point.y * speed) ) * 0.5 + 0.5;
			
			vec2 diff = neighbor + point - fract_uv;
			float dist = length(diff);
			minimum_dist = min(minimum_dist, dist);
			
		}
	}
	
	return minimum_dist;
}

void fragment() {
	float worley = worley(UV, _columns, _rows, TIME * _wobble_speed);
	vec4 color = texture(_color_gradient, vec2(worley, 0.0));
	ALBEDO = color.rgb * COLOR.rgb;
	ALPHA = color.a * COLOR.a;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
