extends State
# when the player walks up to a pushable object they will lean into it for a
# short time before actually pushing it
class_name LeaningPushable

var pushable: Pushable # the crate we are pushing
@onready var destination_check: Area3D = $destination_check # the area we are pushing into
var pushingTimer: float = 0.0 # how long the player has been pushing into the crate
var pushTime: float = 0.1 # how long until the push begins
var initial_push_dir: Vector2 = Vector2.ZERO # cache the push dir so we can check if it changed
var push_margin: float = 0.82 # how far away from the crate should we put the player


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
	
	# also lerp the player to the center of the facing side depending on cardinal push direction
	var destination: Vector3 = Vector3.ZERO
	match initial_push_dir:
		Vector2.RIGHT:
			destination = Vector3(pushable.global_position.x + push_margin, playerCharacter.global_position.y, pushable.global_position.z)
		Vector2.LEFT:
			destination = Vector3(pushable.global_position.x - push_margin, playerCharacter.global_position.y, pushable.global_position.z)
		Vector2.UP:
			destination = Vector3(pushable.global_position.x, playerCharacter.global_position.y, pushable.global_position.z - push_margin)
		Vector2.DOWN:
			destination = Vector3(pushable.global_position.x, playerCharacter.global_position.y, pushable.global_position.z + push_margin)
		_:
			destination = Vector3.ZERO
	# lerp to the destination
	var tween2 = create_tween()
	tween2.tween_method(func(value):
		playerCharacter.global_position = value,
		playerCharacter.global_position,
		destination,
		0.2
	)

func Physics_Update(_delta: float):
	# Get the input direction to see if the player is pushing into the crate
	var input_dir = Input.get_vector("walk_west", "walk_east", "walk_north", "walk_south").round()
	var cardinal_input = DirectionUtils.get_cardinal_direction(input_dir)
	
	# If the player is not pushing
	if input_dir.length() < 0.5:
		# reset the push timer
		pushingTimer = 0.0
		# do nothing
		return

	# if the player pushes away from the crate, transition back to locomote
	if cardinal_input != initial_push_dir:
		Transitioned.emit('Locomote')
		return
			
	# if the player pushes into the crate for pushTime, transition to PushingPushable
	# increment the timer
	pushingTimer += _delta
	if pushingTimer > pushTime:
		Transitioned.emit('PushingPushable', pushable)
		pushingTimer = 0.0
