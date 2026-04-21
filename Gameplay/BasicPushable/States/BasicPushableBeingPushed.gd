extends State

class_name BasicPushableBeingPushed

## This state is for crates and such that slide a given distance then stop.
## The way we handle the actual movement is by accepting player input and
## moving the pushable while in this state. If the player releases the input
## then this state is transitioned out of and the pushable stops moving.

## During physics update, handle player input
func Physics_Update(_delta: float):
	
	# get the input direction for movement
	var input_direction = InputUtils.get_stick_input()

	# if the player is not holding an input, transition out of this state	
	if input_direction.length() < 0.5:
		Transitioned.emit("BasicPushableIdle")
		return
	
	# otherwise move with the input
	var cardinal_speed = InputUtils.get_cardinal_input() * owner.push_speed * -1
	
	owner.velocity.x = cardinal_speed.x
	owner.velocity.z = cardinal_speed.y
	
	owner.move_and_slide()
