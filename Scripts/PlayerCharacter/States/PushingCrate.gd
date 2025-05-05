extends State
# After leaning up against a pushble object (see the LeaningCrate state), the
# player will push the crate one grid square
class_name PushingCrate

var crate # the crate we are pushing
var push_speed: float = 1 # how long it takes to push the crate
var crate_tween : Tween # the tween for the crate
var player_tween : Tween # the tween for the player
@onready var destination_block: StaticBody3D = $destination_block # to block the destination when pushing
var collision_layer: int = 1 # the collision layer for the destination block
var collision_mask: int = 1 # the collision mask for the destination block
var input : Vector2 = Vector2.ZERO # the input direction for pushing
var destination: Vector3 = Vector3.ZERO # the destination for the crate

# on ready, disable the destination block
func _ready():
	collision_layer = destination_block.collision_layer
	collision_mask = destination_block.collision_mask
	destination_block.collision_layer = 0
	destination_block.collision_mask = 0

	
func Enter(extra_data = null):
	assert(!!extra_data, "we need to be passed a crate to push!")
	crate = extra_data

	# our destination is exactly one grid square away from the crate in the direction we are pushing
	# Get the input direction to see if the player is pushing into the crate
	var input_dir = crate.global_position - owner.global_position
	var cardinal_input = DirectionUtils.get_cardinal_direction(Vector2(input_dir.x, input_dir.z))

	# the destination is the crate's current dest + 1
	destination = crate.global_position - Vector3(cardinal_input.x, 0, cardinal_input.y)
	# round the target to a grid square
	destination.x = round(destination.x)
	destination.z = round(destination.z)

	# set the input, to be checked on physics_process
	input = cardinal_input

# during physics update, depending on input, mopve towards target
func Physics_Update(_delta: float):
	# if we are not within 0.1 of the target, move towards it
	if crate.global_position.distance_to(destination) < 0.1:
		crate.apply_central_impulse(Vector3(input.x, 0.0, input.y) * push_speed)
		# move the player towards the crate
		owner.apply_central_impulse(Vector3(input.x, 0.0, input.y) * push_speed)
	else:
		# we have reached the target
		Transitioned.emit("Locomote")
