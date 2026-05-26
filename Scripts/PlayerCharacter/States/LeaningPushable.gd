extends State
# when the player walks up to a pushable object they will lean into it for a
# short time before actually pushing it
class_name LeaningPushable

var pushable: Pushable # the crate we are pushing
var pushingTimer: float = 0.0 # how long the player has been pushing into the crate
var pushTime: float = 0.1 # how long until the push begins
var initial_push_dir: Vector2 = Vector2.ZERO # cache the push dir so we can check if it changed

func Enter(extra_data = null):
	assert(!!extra_data, "we need to be passed a crate to push!")
	pushable = extra_data
	
	# if the pushable is missing required methods, bail out
	if not pushable or not pushable.has_method("stop_being_pushed"):
		push_warning("PushingPushable: No valid pushable object passed in!")
		Transitioned.emit("Locomote")
		return
	
	# reset the push timer
	pushingTimer = 0.0
	
	# figure out which way we are pushing
	var crate_pos = pushable.global_position
	var player_pos = playerCharacter.global_position
	var direction = (crate_pos - player_pos)
	# we're only worried about the x and z axis
	var dir: Vector2 = Vector2(direction.x, direction.z).normalized()
	# Get the cardinal direction
	initial_push_dir = DirectionUtils.get_cardinal_direction(dir)

func Physics_Update(_delta: float):

	if not pushable.can_be_pushed():
		state_machine.travel("Locomote")
		return

	# Get the input direction to see if the player is pushing into the crate
	var cardinal_input = InputUtils.get_cardinal_input()
	
	# If the player is not pushing
	if cardinal_input == Vector2.ZERO:
		# reset the push timer
		pushingTimer = 0.0
		# do nothing
		return
	# if the player pushes away from the crate, transition back to locomote
	if cardinal_input != initial_push_dir:
		Transitioned.emit('Locomote')
		return
	
	# if the player is not pushing into the pushable at an acceptable angle, bail out
	var to_pushable = (pushable.global_transform.origin - playerCharacter.global_transform.origin).normalized()
	var input_direction = InputUtils.get_stick_input()
	if input_direction.dot(to_pushable) < 0.5:
		pushable.stop_being_pushed()
		Transitioned.emit("Locomote")
		return
			
	# if the player pushes into the crate for pushTime, transition to PushingPushable
	# increment the timer
	pushingTimer += _delta
	if pushingTimer > pushTime:
		Transitioned.emit('PushingPushable', pushable)
		pushingTimer = 0.0
