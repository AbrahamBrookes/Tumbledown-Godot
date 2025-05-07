extends State
# After leaning up against a pushble object (see the LeaningCrate state), the
# player will push the crate one grid square
class_name PushingCrate

var crate # the crate we are pushing
var push_speed: float = 1 # how long it takes to push the crate
var crate_tween : Tween # the tween for the crate
var player_tween : Tween # the tween for the player
var collision_layer: int = 1 # the collision layer for the destination block
var collision_mask: int = 1 # the collision mask for the destination block
var cardinal_input : Vector2 = Vector2.ZERO # the input direction for pushing
var destination: Vector3 = Vector3.ZERO # the destination for the crate

# we'll cache the players start position so we can track how 

	
func Enter(data: pushy_crate = null):
	assert(!!data, "we need to be passed a crate to push!")
	crate = data
	
	playerCharacter.freeze = true
	freeze_crate(true)
	
	var push_dir = playerCharacter.global_position - crate.global_position
	var cardinal_push = DirectionUtils.get_cardinal_direction(Vector2(push_dir.x, push_dir.z))
	
	var tween1 = create_tween()
	tween1.parallel().tween_property(
		playerCharacter, 
		"global_position", 
		playerCharacter.global_position + Vector3(cardinal_push.x, 0.0, cardinal_push.y),
		0.5
	)
	
	var tween2 = create_tween()
	tween2.tween_property(
		crate,
		"global_position", 
		crate.global_position + Vector3(cardinal_push.x, 0.0, cardinal_push.y),
		0.5
	)
	tween2.finished.connect(func(): 
		Transitioned.emit("LeaningCrate", crate)
		playerCharacter.freeze = false
		freeze_crate(false)
	)

func freeze_crate(freeze: bool = true):
	crate.axis_lock_linear_x = !freeze
	crate.axis_lock_linear_z = !freeze
	
	crate.freeze_mode = RigidBody3D.FREEZE_MODE_KINEMATIC
	crate.freeze = freeze
	
