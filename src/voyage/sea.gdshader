shader_type canvas_item;

varying vec2 local_pos;

uniform vec4 deep_color : source_color = vec4(0.07, 0.36, 0.48, 1.0);
uniform vec4 mid_color : source_color = vec4(0.14, 0.62, 0.7, 1.0);
uniform vec4 shoal_color : source_color = vec4(0.42, 0.84, 0.78, 1.0);
uniform vec4 foam_color : source_color = vec4(0.94, 1.0, 0.98, 1.0);
uniform vec4 ink_color : source_color = vec4(0.96, 0.93, 0.82, 1.0);

void vertex() {
	local_pos = VERTEX;
}

void fragment() {
	vec2 uv = local_pos * 0.0032;
	float t = TIME * 0.35;
	float depth = clamp(uv.y * 0.35 + 0.45 + sin(uv.x * 1.4 + t) * 0.08, 0.0, 1.0);
	vec3 sea = mix(shoal_color.rgb, mid_color.rgb, smoothstep(0.15, 0.55, depth));
	sea = mix(sea, deep_color.rgb, smoothstep(0.45, 0.95, depth));

	float roll = sin(uv.y * 14.0 + sin(uv.x * 2.2 + t) * 1.1 + t * 0.6);
	vec3 trough = mix(sea, deep_color.rgb, 0.22);
	vec3 crest = mix(sea, foam_color.rgb, 0.16);
	sea = mix(trough, crest, smoothstep(-0.2, 0.75, roll));
	float lip = smoothstep(0.62, 0.82, roll) * (1.0 - smoothstep(0.82, 0.97, roll));
	sea = mix(sea, foam_color.rgb, lip * 0.4);

	float lat = 1.0 - smoothstep(0.0, 0.004, abs(fract(uv.y * 0.85) - 0.5));
	float lon = 1.0 - smoothstep(0.0, 0.004, abs(fract(uv.x * 1.05) - 0.5));
	sea = mix(sea, ink_color.rgb, clamp(lat + lon, 0.0, 1.0) * 0.08);

	vec2 cell = floor(uv * 11.0);
	vec2 cell_uv = fract(uv * 11.0) - vec2(0.5);
	float spark = fract(sin(dot(cell, vec2(27.1, 91.7))) * 43758.5);
	float bubble = smoothstep(0.22, 0.02, length(cell_uv)) * step(0.84, spark);
	sea = mix(sea, foam_color.rgb, bubble * 0.8);

	COLOR = vec4(sea, 1.0);
}
