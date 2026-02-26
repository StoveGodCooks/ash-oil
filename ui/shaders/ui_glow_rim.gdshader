shader_type canvas_item;

uniform vec4 base_color : source_color = vec4(0.09, 0.14, 0.20, 0.86);
uniform vec4 rim_color : source_color = vec4(0.56, 0.85, 1.0, 1.0);
uniform float rim_width : hint_range(0.01, 0.45, 0.005) = 0.08;
uniform float inner_glow : hint_range(0.0, 1.0, 0.01) = 0.14;
uniform float inner_radius : hint_range(0.0, 1.0, 0.01) = 0.62;
uniform float glow_strength : hint_range(0.0, 2.0, 0.01) = 0.60;
uniform float pulse_speed : hint_range(0.0, 6.0, 0.01) = 1.20;
uniform float pulse_amount : hint_range(0.0, 1.0, 0.01) = 0.20;

void fragment() {
	vec2 p = UV * 2.0 - vec2(1.0);
	float d = length(p);
	float inside = 1.0 - smoothstep(0.98, 1.02, d);
	float rim = smoothstep(1.0 - rim_width, 1.0, d) * (1.0 - smoothstep(1.0, 1.03, d));
	float inner = 1.0 - smoothstep(0.0, inner_radius, d);
	float pulse = 1.0 + sin(TIME * pulse_speed) * pulse_amount;
	vec3 c = base_color.rgb;
	c += rim_color.rgb * rim * glow_strength * pulse;
	c += rim_color.rgb * inner * inner_glow;
	float alpha = base_color.a * inside + rim * glow_strength * 0.55;
	COLOR = vec4(c, alpha);
}
