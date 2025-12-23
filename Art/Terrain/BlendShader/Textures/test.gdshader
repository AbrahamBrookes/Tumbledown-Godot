shader_type spatial;
render_mode specular_toon;

uniform float texture_scale = 1.0;

// grass textures - rougness is in the dif.a
uniform sampler2D grass_dif;
uniform sampler2D grass_nor;

// dirt textures - rougness is in the dif.a
uniform sampler2D dirt_dif;
uniform sampler2D dirt_nor;

// edge texture for masking the world space grass and dirt
// against the mesh space edge iamge. the r channel hides/shows
// the dirt and the g channel hides/shows the grass
uniform sampler2D edge_mask;

// the raster diffuse image of the mesh-space grass edge
uniform sampler2D grass_edge_dif;
uniform sampler2D grass_edge_nor;

varying vec3 world_pos;

void vertex() {
	    // Calculate per-vertex world position
	    world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	}

void fragment() {
	// Sample the edge mask using UV coordinates (mesh space)
	vec4 mask = texture(edge_mask, UV);
	float dirt_mask = mask.r;   // Red channel = dirt areas
	float grass_mask = mask.g;  // Green channel = grass areas
	
	// Calculate world-space UV coordinates for tiling textures
	vec2 world_uv = world_pos.xz * texture_scale;
	
	// Sample world-space textures
	vec4 grass_colour = texture(grass_dif, world_uv);
	vec4 dirt_colour = texture(dirt_dif, world_uv);
	vec3 grass_normal = texture(grass_nor, world_uv).rgb;
	vec3 dirt_normal = texture(dirt_nor, world_uv).rgb;
	
	// sample the grass edge image
	vec4 edge_colour = texture(grass_edge_dif, UV);
	vec4 edge_normal = texture(grass_edge_nor, UV);
	
	// Blend between grass and dirt based on mask
	// Red areas = dirt, Green areas = grass
	vec3 final_albedo = mix(
		dirt_colour.rgb * dirt_mask,     // Dirt in red areas
		grass_colour.rgb * grass_mask,   // Grass in green areas
		grass_mask                      // Use grass mask as blend factor
	);

	// lay the edge diffuse on top
	final_albedo += texture(grass_edge_dif, UV).rgb;
	
	vec3 final_normal = mix(
		dirt_normal * dirt_mask,
		grass_normal * grass_mask,
		grass_mask
	);

	// lay the edge normal on top
	final_normal += texture(grass_edge_nor, UV).rgb;
	
	// Output
	ALBEDO = final_albedo;
	NORMAL_MAP = final_normal;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
