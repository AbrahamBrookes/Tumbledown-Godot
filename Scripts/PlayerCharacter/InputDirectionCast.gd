extends Node3D

## This script simply rotates the raycast in the direction of input regardless of player
## movement or any other stuff. At time of writing this is used to check that the player
## is pushing into a pushable (because the player is facing the pushable but they might
## be pushing input away from the crate)
class_name InputDirectionCast

func _physics_process(_delta: float) -> void:
	var input_direction = Vector3(
		Input.get_action_strength("walk_east") - Input.get_action_strength("walk_west"),
		0,
		Input.get_action_strength("walk_south") - Input.get_action_strength("walk_north")
	)
	
	if input_direction.length() > 0.01:
		look_at(global_transform.origin + input_direction, Vector3.UP)
