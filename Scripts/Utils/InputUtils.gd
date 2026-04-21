extends Node

## A DRY helper to get the current input
func get_stick_input() -> Vector3:
	return Vector3(
		Input.get_action_strength("walk_east") - Input.get_action_strength("walk_west"),
		0,
		Input.get_action_strength("walk_south") - Input.get_action_strength("walk_north")
	)

# Get the player input snapped to nearest cardinal direction
func get_cardinal_input() -> Vector2:
	var input_dir = Input.get_vector("walk_west", "walk_east", "walk_north", "walk_south").round()
	return DirectionUtils.get_cardinal_direction(input_dir)
