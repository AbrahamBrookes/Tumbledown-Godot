shader_type spatial;
render_mode specular_schlick_ggx;

uniform sampler2D albedo_texture : source_color;
uniform float roughness : hint_range(0,1) = 0.5;
uniform float metallic : hint_range(0,1) = 0.0;
uniform float specular = 0.5;

uniform float sway_strength : hint_range(0, 1) = 0.2;
uniform float sway_speed : hint_range(0, 10) = 1.5;
uniform float sway_distance : hint_range(0, 10) = 1.5;
uniform float shimmer_strength : hint_range(0, 0.1) = 0.03;
uniform float shimmer_speed : hint_range(0, 50) = 18.0;

void vertex() {
    float group_id = UV2.x;
    float phase = group_id * 6.2831;

    // Main sway (slow, large)
    float sway_amount = UV2.y * sway_distance;
    float sway = sin(TIME * sway_speed + phase) * sway_strength * sway_amount;

    // Shimmer (fast, small, with some spatial variation)
    float shimmer_phase = group_id * 12.566 + VERTEX.y * 2.0; // more spatial variety
    float shimmer = sin(TIME * shimmer_speed + shimmer_phase) * shimmer_strength * sway_amount;

    VERTEX.x += sway;
	VERTEX.y += shimmer;
}

void fragment() {
	vec4 tex = texture(albedo_texture, UV);
	ALBEDO = tex.rgb;
	ROUGHNESS = roughness;
	METALLIC = metallic;
	SPECULAR = specular;
}