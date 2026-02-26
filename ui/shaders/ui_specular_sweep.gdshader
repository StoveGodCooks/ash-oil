shader_type canvas_item;

uniform vec4 base_tint : source_color = vec4(0.0, 0.0, 0.0, 0.0);
uniform vec4 sweep_color : source_color = vec4(0.92, 0.98, 1.0, 1.0);
uniform float sweep_progress : hint_range(-1.0, 2.0, 0.001) = -0.30;
uniform float sweep_width : hint_range(0.02, 0.8, 0.005) = 0.14;
uniform float sweep_angle : hint_range(-3.1415, 3.1415, 0.001) = 0.35;
uniform float intensity : hint_range(0.0, 2.0, 0.01) = 1.0;
uniform float softness : hint_range(0.2, 3.0, 0.01) = 1.4;

void fragment() {
	vec2 center_uv = UV - vec2(0.5);
	vec2 dir = normalize(vec2(cos(sweep_angle), sin(sweep_angle)));
	float coord = dot(center_uv, dir) + 0.5;
	float dist = abs(coord - sweep_progress);
	float sweep = 1.0 - smoothstep(sweep_width, sweep_width * softness, dist);
	float edge = smoothstep(0.0, 0.08, UV.x) * smoothstep(0.0, 0.08, UV.y) *
		(1.0 - smoothstep(0.92, 1.0, UV.x)) * (1.0 - smoothstep(0.92, 1.0, UV.y));
	float spec = sweep * edge * intensity;
	vec3 c = base_tint.rgb + sweep_color.rgb * spec;
	float a = clamp(base_tint.a + spec * sweep_color.a, 0.0, 1.0);
	COLOR = vec4(c, a);
}
