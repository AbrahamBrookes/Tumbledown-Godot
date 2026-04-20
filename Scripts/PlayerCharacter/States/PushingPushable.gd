extends State

class_name PushingPushable

## This state is used to push objects that can be pushed. On enter we will
## call "be_pushed" on the extra data (the pushable object) to let it know
## we are pushing it. The pushable travels by itself (it is a character body
## with its own state machine and movement logic). The player can always bail
## on the push as well by releasing movement input or walking away.

# the thing we are pushing
var pushable_object: Pushable = null

func Enter(pushable = null):
	# if the pushable can't be pushed, bail out
	if not pushable or not pushable.has_method("be_pushed"):
		push_warning("PushingPushable: No valid pushable object passed in!")
		Transitioned.emit("Locomote")
		return

	pushable_object = pushable

	# tell the pushable we are pushing it
	pushable_object.be_pushed(playerCharacter)

# in physics process, check if we should stop pushing
func Physics_Update(delta: float) -> void:
	# if we have no pushable, bail out
	if not pushable_object:
		Transitioned.emit("Locomote")
		return
	
	var input_direction = Vector3(
		Input.get_action_strength("walk_east") - Input.get_action_strength("walk_west"),
		0,
		Input.get_action_strength("walk_south") - Input.get_action_strength("walk_north")
	).normalized()
	
	var move_direction = input_direction * pushable_object.push_speed
	
	desired_velocity.x = move_direction.x
	desired_velocity.z = move_direction.z

	# if there is no input, bail out
	if input_direction.length() < 0.5:
		pushable_object.stop_being_pushed()
		Transitioned.emit("LeaningPushable", pushable_object)
		return

	# if we have turned away from the pushable, bail out
	var to_pushable = (pushable_object.global_transform.origin - playerCharacter.global_transform.origin).normalized()
	if input_direction.dot(to_pushable) < 0.75:
		pushable_object.stop_being_pushed()
		Transitioned.emit("Locomote")
		return
