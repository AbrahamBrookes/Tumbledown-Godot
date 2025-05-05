extends State
# when the player walks up to a pushable object they will lean into it for a
# short time before actually pushing it
class_name LeaningCrate

var crate: Node3D # the crate we are pushing
@onready var destination_check: Area3D = $destination_check # the area we are pushing into
var pushingTimer: float = 0.0 # how long the player has been pushing into the crate
var pushTime: float = 0.3 # how long until the push begins
var push_dir: Vector2 = Vector2.ZERO # cache the push dir so we can check if it changed
var push_margin: float = 0.82 # how far away from the crate should we put the player


func Enter(extra_data = null):
	assert(!!extra_data, "we need to be passed a crate to push!")
	crate = extra_data
	
	# lerp to face the crate
	var crate_pos = crate.global_position
	var player_pos = playerCharacter.global_position
	var direction = (crate_pos - player_pos)
	# we're only worried about the x and z axis
	var dir: Vector2 = Vector2(direction.x, direction.z).normalized()
	# Get the cardinal direction
	push_dir = DirectionUtils.get_cardinal_direction(dir)
	
	var mesh = playerCharacter.get_node("SkinnedMesh")
	var from = mesh.global_transform.basis.get_rotation_quaternion()

	# Calculate target direction in 3D
	var target_dir = Vector3(push_dir.x, 0, push_dir.y).normalized()
	var to_basis = Basis().looking_at(target_dir, Vector3.UP)
	var to = to_basis.get_rotation_quaternion()

	var tween = create_tween()
	tween.tween_method(func(value):
		mesh.global_transform.basis = Basis(value),
		from,
		to,
		0.2
	)

	# also lerp the player to the center of the facing side depending on cardinal push direction
	var destination: Vector3 = Vector3.ZERO
	match push_dir:
		Vector2.RIGHT:
			destination = Vector3(crate.global_position.x + push_margin, playerCharacter.global_position.y, crate.global_position.z)
		Vector2.LEFT:
			destination = Vector3(crate.global_position.x - push_margin, playerCharacter.global_position.y, crate.global_position.z)
		Vector2.UP:
			destination = Vector3(crate.global_position.x, playerCharacter.global_position.y, crate.global_position.z - push_margin)
		Vector2.DOWN:
			destination = Vector3(crate.global_position.x, playerCharacter.global_position.y, crate.global_position.z + push_margin)
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
	# reset the push timer
	pushingTimer = 0.0

func Physics_Update(_delta: float):
	
	# Get the input direction to see if the player is pushing into the crate
	var input_dir = Input.get_vector("walk_west", "walk_east", "walk_north", "walk_south").round()
	var cardinal_input = DirectionUtils.get_cardinal_direction(input_dir)
	
	# If the player is not pushing
	if cardinal_input == Vector2.ZERO:
		# reset the timer
		pushingTimer = 0.0
		return

	# if the player pushes away from the crate, transition back to locomote
	if cardinal_input != push_dir:
		Transitioned.emit('Locomote')
		return
			
	# if the player pushes into the crate for pushTime, transition to PushingCrate
	# increment the timer
	pushingTimer += _delta
	if pushingTimer > pushTime:
		# finally check if we can push the crate
		# the destination is the crate's current dest + 1
		var destination = crate.global_position - Vector3(cardinal_input.x, 0, cardinal_input.y)
		# move the destination_check Area3D to the destination and check for overlap
		destination_check.global_position = destination

		# check if the destination is clear
		var overlap = destination_check.get_overlapping_bodies()
		if overlap.size() > 0:
			# print them
			for body in overlap:
				print("overlap with: ", body.name)
			# if there is something in the way, we can't push
			Transitioned.emit("LeaningCrate", crate)
			return

		Transitioned.emit('PushingCrate', crate)
		pushingTimer = 0.0
