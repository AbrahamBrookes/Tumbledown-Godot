shader_type spatial;
render_mode specular_schlick_ggx;

uniform sampler2D albedo_texture : source_color;
uniform float roughness : hint_range(0,1) = 0.5;
uniform float metallic : hint_range(0,1) = 0.0;
uniform float specular = 0.5;

uniform float sway_strength : hint_range(0, 1) = 0.2;
uniform float sway_speed : hint_range(0, 10) = 2.0;
uniform float blade_base = 0.0;   // Z position of the base of the blade
uniform float blade_tip = 10.0;    // Z position of the tip of the blade

void vertex() {
	float blade_id = UV2.x;
	float phase = blade_id * 6.2831;
	float sway = sin(TIME * sway_speed + phase) * sway_strength;

	// Normalize the vertex's Z position between base and tip
	float tip_factor = clamp((VERTEX.y - blade_base) / (blade_tip - blade_base), 0.0, 1.0);

	// Optionally, use a smoothstep for even smoother fade
	tip_factor = smoothstep(0.0, 1.0, tip_factor);

	// Apply sway, fading in toward the tip
	VERTEX.x += sway * tip_factor;
}

void fragment() {
	vec4 tex = texture(albedo_texture, UV);
	ALBEDO = tex.rgb;
	ROUGHNESS = roughness;
	METALLIC = metallic;
	SPECULAR = specular;
}