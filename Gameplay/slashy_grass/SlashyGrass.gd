extends Node3D

## The SlashyGrass object can be slashed by the player. We have a pre-slash mesh
## and a post-slash mesh and a particle effect. When the player slashes, the pre
## slash mesh disappears, the post slash mesh appears, and the particle system
## emits so it looks like the grass is slashed. We might also drop loot.
class_name SlashyGrass

# the pre- and post- slash meshes
@export var pre_slash_mesh: MeshInstance3D
@export var post_slash_mesh: MeshInstance3D

# the particle system
@export var particles: CPUParticles3D

# our collision area - for detecting actors and angling the grass toward them slightly
@export var area: Area3D

# the characterbody we are angling toward
var target_characterbody: CharacterBody3D = null

# the position we are in originally, for resetting
var original_position: Vector3

# set up in ready
func _ready():
	pre_slash_mesh.visible = true
	post_slash_mesh.visible = false
	original_position = global_transform.origin

# when the slashable component is slashed, run our mesh swapout and spawn code
func _on_slashable_slashed(damage: Damage) -> void:
	# only slash if the pre-slash mesh is visible
	if not pre_slash_mesh.visible:
		return
	# only slash if the damage is SHARP
	if damage.type == Damage.DamageType.SHARP:
		# hide the pre-slash mesh
		pre_slash_mesh.visible = false
		# show the post-slash mesh
		post_slash_mesh.visible = true
		# run the particles if the pr
		particles.emitting = true
		particles.restart()

# when a CharacterBody3d enters the collision area angle self towards it a little
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		target_characterbody = body

# when a CharacterBody3d exits the collision area, stop angling toward it
func _on_area_3d_body_exited(body: Node3D) -> void:
	if body == target_characterbody:
		target_characterbody = null

func _process(delta: float) -> void:
	# when we have something moving through us, angle the pre-slash mesh slightly toward it
	if target_characterbody and pre_slash_mesh.visible:
		# Get direction to target, ignoring vertical difference
		var to_target := target_characterbody.global_transform.origin - global_transform.origin
		to_target.y = 0.0
		if to_target.length() > 0.01:
			to_target = to_target.normalized()
			var tilt_strength := 0.2
			# X and Z tilt: lean toward target, keep Y rotation unchanged
			var tilt := Vector3(-to_target.z * tilt_strength, pre_slash_mesh.transform.basis.get_euler().y, to_target.x * tilt_strength)
			var target_rot := Basis().from_euler(tilt)
			# Preserve original scale
			var current_basis := pre_slash_mesh.transform.basis.orthonormalized()
			var current_scale := pre_slash_mesh.transform.basis.get_scale()
			var new_basis := current_basis.slerp(target_rot, 0.15)
			new_basis = new_basis.scaled(current_scale)
			pre_slash_mesh.transform.basis = new_basis
