shader_type canvas_item;

uniform vec4 deep_color : source_color = vec4(0.067, 0.169, 0.188, 1.0);
uniform vec4 mid_color : source_color = vec4(0.145, 0.345, 0.365, 1.0);
uniform vec4 shoal_color : source_color = vec4(0.416, 0.569, 0.522, 1.0);
uniform vec4 ink_color : source_color = vec4(0.910, 0.855, 0.710, 1.0);

void fragment() {
	vec2 uv = UV;
	float drift = TIME * 0.03;
	float swell = sin(uv.x * 2.4 + uv.y * 1.3 + drift) * 0.06;
	float depth = clamp(uv.y * 0.55 + 0.15 + swell, 0.0, 1.0);
	vec3 sea = mix(shoal_color.rgb, mid_color.rgb, smoothstep(0.0, 0.55, depth));
	sea = mix(sea, deep_color.rgb, smoothstep(0.35, 1.0, depth));

	float lat = 1.0 - smoothstep(0.0, 0.018, abs(fract(uv.y * 2.6) - 0.5));
	float lon = 1.0 - smoothstep(0.0, 0.018, abs(fract(uv.x * 3.1 + drift * 0.2) - 0.5));
	sea = mix(sea, ink_color.rgb, clamp(lat + lon, 0.0, 1.0) * 0.16);

	float grain = fract(sin(dot(uv * 40.0 + drift, vec2(12.9898, 78.233))) * 43758.5453);
	sea += (grain - 0.5) * 0.035;
	COLOR = vec4(sea, 1.0);
}
