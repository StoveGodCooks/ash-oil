shader_type canvas_item;

uniform vec4 tint_color : source_color = vec4(0.04, 0.08, 0.12, 1.0);
uniform float vignette_strength : hint_range(0.0, 1.0, 0.001) = 0.40;
uniform float grain_strength : hint_range(0.0, 0.5, 0.001) = 0.035;
uniform float fog_strength : hint_range(0.0, 1.0, 0.001) = 0.22;
uniform float dust_strength : hint_range(0.0, 0.6, 0.001) = 0.12;
uniform float scanline_strength : hint_range(0.0, 0.6, 0.001) = 0.08;
uniform float scanlines_enabled : hint_range(0.0, 1.0, 0.001) = 0.0;

float hash12(vec2 p) {
	vec3 p3 = fract(vec3(p.xyx) * 0.1031);
	p3 += dot(p3, p3.yzx + 33.33);
	return fract((p3.x + p3.y) * p3.z);
}

void fragment() {
	vec2 uv = UV;
	vec2 center_uv = uv - vec2(0.5);

	float vignette = smoothstep(0.35, 0.92, length(center_uv));
	float grain = hash12(uv * vec2(1440.0, 810.0) + vec2(TIME * 50.0, TIME * 31.0)) - 0.5;

	float fog_a = sin((uv.y + TIME * 0.018) * 9.0);
	float fog_b = cos((uv.x * 1.2 - TIME * 0.014) * 11.0);
	float fog = (fog_a * fog_b) * 0.5 + 0.5;

	vec2 dust_uv = floor((uv + vec2(TIME * 0.010, -TIME * 0.024)) * vec2(240.0, 140.0));
	float dust = step(0.996, hash12(dust_uv));

	float scan = (sin((uv.y + TIME * 0.025) * 1700.0) * 0.5 + 0.5) * scanlines_enabled;

	float alpha = vignette * vignette_strength;
	alpha += abs(grain) * grain_strength;
	alpha += fog * fog_strength * 0.22;
	alpha += dust * dust_strength;
	alpha += scan * scanline_strength;
	alpha = clamp(alpha, 0.0, 0.68);

	COLOR = vec4(tint_color.rgb, alpha);
}
