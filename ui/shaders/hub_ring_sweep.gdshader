shader_type canvas_item;

uniform vec4 ring_color : source_color = vec4(0.26, 0.66, 0.98, 0.85);
uniform vec4 sweep_color : source_color = vec4(0.98, 0.84, 0.45, 1.0);
uniform float ring_radius : hint_range(0.05, 0.7, 0.001) = 0.36;
uniform float ring_thickness : hint_range(0.002, 0.2, 0.001) = 0.028;
uniform float sweep_speed : hint_range(0.0, 2.0, 0.001) = 0.12;
uniform float tick_count : hint_range(4.0, 256.0, 1.0) = 72.0;
uniform float tick_strength : hint_range(0.0, 1.0, 0.01) = 0.26;
uniform float pulse_speed : hint_range(0.0, 4.0, 0.001) = 1.0;
uniform float pulse_amp : hint_range(0.0, 1.0, 0.001) = 0.12;

uniform float overlay_alpha : hint_range(0.0, 1.0, 0.001) = 0.0;
uniform float wipe_radius : hint_range(0.0, 1.6, 0.001) = 1.2;
uniform float warp_strength : hint_range(0.0, 0.25, 0.001) = 0.035;
uniform vec2 wipe_center = vec2(0.5, 0.5);

void fragment() {
	vec2 p = UV - vec2(0.5);
	float radius = length(p);
	float ring = 1.0 - smoothstep(ring_thickness, ring_thickness + 0.01, abs(radius - ring_radius));
	float ang = atan(p.y, p.x);

	float sweep = smoothstep(0.78, 1.0, cos(ang - TIME * sweep_speed * 6.28318530718));
	float ticks = smoothstep(0.88, 1.0, abs(sin(ang * tick_count))) * tick_strength;
	float pulse = 1.0 + sin(TIME * pulse_speed) * pulse_amp;

	vec3 ring_rgb = ring_color.rgb * ring * pulse;
	ring_rgb += sweep_color.rgb * ring * sweep * 0.85;
	ring_rgb += sweep_color.rgb * ring * ticks;
	float ring_alpha = ring * ring_color.a;

	vec2 wp = UV - wipe_center;
	float wr = length(wp);
	float wang = atan(wp.y, wp.x);
	float warp = sin(wang * 6.0 + TIME * 5.0 + wr * 40.0) * warp_strength;
	float outside = smoothstep(wipe_radius - 0.03 + warp, wipe_radius + 0.03 + warp, wr);
	vec4 overlay = vec4(sweep_color.rgb, outside * overlay_alpha);

	vec4 out_color = vec4(ring_rgb, ring_alpha) + overlay;
	out_color.a = clamp(out_color.a, 0.0, 1.0);
	COLOR = out_color;
}
