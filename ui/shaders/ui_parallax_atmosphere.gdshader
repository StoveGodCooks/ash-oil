shader_type canvas_item;

// Parallax Atmosphere Shader for Hub Background
// Provides layered parallax, phase-based coloring, noise texture, and vignette effect
// Designed for professional studio card game aesthetic

uniform float phase_intensity: hint_range(0.0, 1.0) = 0.8;
uniform vec3 phase_color: hint_color = vec3(0.2, 0.18, 0.15);  // PHASE 1: Dark stone/sand
uniform float noise_strength: hint_range(0.0, 0.5) = 0.2;
uniform float parallax_speed: hint_range(0.0, 0.2) = 0.05;
uniform float vignette_strength: hint_range(0.0, 1.0) = 0.15;
uniform float pulse_speed: hint_range(0.1, 2.0) = 0.5;
uniform float pulse_amount: hint_range(0.0, 0.1) = 0.04;

// Layered gradient colors
vec3 get_gradient_color(vec2 uv) {
	// Bottom-to-top gradient for depth
	vec3 color_top = phase_color * 0.8;  // Darker at top
	vec3 color_bottom = phase_color * 1.2;  // Lighter at bottom
	vec3 gradient = mix(color_bottom, color_top, uv.y);
	return gradient;
}

// 3D Simplex-like noise (approximated with multiple sine waves for performance)
float noise_3d(vec3 p) {
	return sin(p.x * 1.5) * cos(p.y * 1.3) * sin(p.z * 0.7) * 0.5 + 0.5;
}

// Fractional Brownian Motion for organic texture
float fbm(vec2 uv, float time) {
	float value = 0.0;
	float amplitude = 1.0;
	float frequency = 1.0;
	float max_value = 0.0;

	for (int i = 0; i < 3; i++) {
		// Animated layered noise
		vec2 offset_uv = uv * frequency + vec2(time * 0.1 * (float(i) + 1.0), time * 0.05);
		value += amplitude * noise_3d(vec3(offset_uv, time * pulse_speed * 0.2));
		max_value += amplitude;
		amplitude *= 0.5;
		frequency *= 2.0;
	}

	return value / max_value;
}

// Vignette effect (darkens edges)
float vignette(vec2 uv) {
	uv = uv * 2.0 - 1.0;  // Remap to -1..1
	float dist = length(uv);
	return smoothstep(1.4, 0.0, dist * vignette_strength);
}

// Parallax layer calculation
vec2 parallax_offset(vec2 uv, float depth, vec2 mouse_pos, float time) {
	// Depth-based parallax movement
	vec2 offset = (mouse_pos - 0.5) * parallax_speed * depth;

	// Subtle wave motion
	offset += vec2(sin(time * 0.3 + uv.x * 2.0) * 0.02,
	               cos(time * 0.2 + uv.y * 2.0) * 0.02) * (1.0 - depth);

	return uv + offset;
}

void fragment() {
	vec2 uv = UV;
	float time = TIME;

	// Get base gradient color
	vec3 base_color = get_gradient_color(uv);

	// Apply parallax to base color (far background)
	vec2 parallax_uv_far = parallax_offset(uv, 0.1, SCREEN_UV, time);
	vec3 color_far = get_gradient_color(parallax_uv_far) * 0.7;

	// Mid-ground parallax
	vec2 parallax_uv_mid = parallax_offset(uv, 0.5, SCREEN_UV, time);
	vec3 color_mid = get_gradient_color(parallax_uv_mid) * 0.5;

	// Blend parallax layers
	vec3 final_color = base_color + color_far * 0.3 + color_mid * 0.2;

	// Add animated noise/grain texture
	float grain = fbm(uv, time);
	final_color += (grain - 0.5) * noise_strength;

	// Subtle color pulsing (breathing effect)
	float pulse = sin(time * pulse_speed) * pulse_amount;
	final_color *= (1.0 + pulse);

	// Apply vignette darkening at edges
	float vign = vignette(uv);
	final_color *= mix(1.0, vign, vignette_strength * 0.5);

	// Ensure color stays in valid range
	final_color = clamp(final_color, 0.0, 1.0);

	COLOR = vec4(final_color, 1.0);
}
