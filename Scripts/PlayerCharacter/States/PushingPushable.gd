extends State

class_name PushingPushable

## This state is used to push objects that can be pushed. On enter we will
## call "be_pushed" on the extra data (the pushable object) to let it know
## we are pushing it. The pushable travels by itself (it is a character body
## with its own state machine and movement logic). The player can always bail
## on the push as well by releasing movement input or walking away.

# the thing we are pushing
var pushable_object = null

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
func PhysicsProcess(delta: float) -> void:
	# if we have no pushable, bail out
	if not pushable_object:
		Transitioned.emit("Locomote")
		return
	
	var input_direction = Vector3(
		Input.get_action_strength("walk_east") - Input.get_action_strength("walk_west"),
		0,
		Input.get_action_strength("walk_south") - Input.get_action_strength("walk_north")
	).normalized()

	# if there is no input, bail out
	if input_direction == Vector3.ZERO:
		Transitioned.emit("Locomote")
		return

	# if we have turned away from the pushable, bail out
	var to_pushable = (pushable_object.global_transform.origin - playerCharacter.global_transform.origin).normalized()
	if input_direction.dot(to_pushable) < 0.5:
		Transitioned.emit("Locomote")
		return

# whenever we exit this state, tell the pushable to stop being pushed -
# it might keep travelling on its own for a bit still
func Exit():
	if pushable_object and pushable_object.has_method("stop_being_pushed"):
		pushable_object.stop_being_pushed()
	pushable_object = null