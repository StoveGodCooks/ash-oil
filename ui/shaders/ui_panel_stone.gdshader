shader_type canvas_item;

uniform vec4 tint_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform sampler2D texture_albedo : source_color;
uniform float texture_strength : hint_range(0.0, 1.0) = 0.35;
uniform float edge_glow_strength : hint_range(0.0, 1.0) = 0.15;
uniform vec4 edge_glow_color : source_color = vec4(0.83, 0.65, 0.40, 1.0);

// Hit Flash
uniform float flash_intensity : hint_range(0.0, 1.0) = 0.0;
uniform vec4 flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
	vec4 base_tex = texture(texture_albedo, UV);
	vec2 p = UV * 2.0 - 1.0;
	float dist = length(p);
	
	// Create a soft rim highlight based on the edge of the control
	float edge = smoothstep(0.85, 1.0, max(abs(p.x), abs(p.y)));
	
	// Blend the texture with the tint color
	vec3 final_color = mix(tint_color.rgb, tint_color.rgb * base_tex.rgb, texture_strength);
	
	// Add the edge glow for a "beveled/rim-lit" look
	final_color += edge_glow_color.rgb * edge * edge_glow_strength;
	
	// Apply Hit Flash
	final_color = mix(final_color, flash_color.rgb, flash_intensity);
	
	COLOR = vec4(final_color, tint_color.a * base_tex.a);
}
