extends State

class_name BasicPushableBeingPushed

## This state is for crates and such that slide a given distance then stop.
## The way we handle the actual movement is by accepting player input and
## moving the pushable while in this state. If the player releases the input
## then this state is transitioned out of and the pushable stops moving.

## During physics update, handle player input
func Physics_Update(delta: float):
	
	# get the input direction for movement
	var input_direction = Vector3(
		Input.get_action_strength("walk_east") - Input.get_action_strength("walk_west"),
		0,
		Input.get_action_strength("walk_south") - Input.get_action_strength("walk_north")
	)

	# if the player is not holding an input, transition out of this state	
	if input_direction.length() < 0.5:
		Transitioned.emit("BasicPushableIdle")
		return
	
	# otherwise move with the input
	input_direction = input_direction.normalized() * owner.push_speed
	
	owner.velocity.x = input_direction.x
	owner.velocity.z = input_direction.z
	
	owner.move_and_slide()
