extends State
class_name Locomote

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var LERP_SPEED = 0.35
@export var acceleration := 10.0
var target_velocity := Vector3.ZERO

var can_slash = true

## we need some coyote time before we prevent jumping
@export var coyote_timer: Timer
var in_coyote_time: bool = true
var was_on_floor = true

func Enter(extra_data = null):
	owner.animTree.set("parameters/AnimSpeed/scale", 1.10)


func Exit():
	pass


func Update(_delta: float):
	pass


func Physics_Update(delta: float):
	# if the player presses interact, interact
	if Input.is_action_just_pressed('interact'):
		playerCharacter.interactor.interact()
		return

	# if the player presses crouch, crouch
	if Input.is_action_just_pressed('crouch'):
		Transitioned.emit('Crouching')
		return

	# if the player presses slash, slash
	if Input.is_action_just_pressed("slash"):
		Transitioned.emit("Slash")
		return

	# handle coyote time
	var on_floor = playerCharacter.is_on_floor()
	if was_on_floor and not on_floor:
		coyote_timer.start()
		in_coyote_time = true
	if on_floor:
		in_coyote_time = true
		coyote_timer.stop()
	was_on_floor = on_floor
	
	# if the player presses jump, jump
	if Input.is_action_just_pressed("jump"):
		if in_coyote_time:
			Transitioned.emit("Jumping")
			return
	
	input_walk(delta)


func input_walk(delta: float):
	# update the animation tree with the real velocity
	state_machine.animTree.set("parameters/StateMachine/Locomote/blend_position", playerCharacter.velocity.length() / playerCharacter.move_speed)
	
	var input_direction = Vector3(
		Input.get_action_strength("walk_east") - Input.get_action_strength("walk_west"),
		0,
		Input.get_action_strength("walk_south") - Input.get_action_strength("walk_north")
	)

	input_direction = input_direction.normalized() * playerCharacter.move_speed
	
	desired_velocity.x = input_direction.x
	desired_velocity.z = input_direction.z
	
	# Convert input to world direction
	#var input_dir = Input.get_vector("walk_west", "walk_east", "walk_north", "walk_south")
	#move_dir = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if not playerCharacter.is_on_floor():
		var fall_multiplier := 3.5
		var max_fall_speed := 50.0  # tweak this

		# Apply gravity
		desired_velocity.y = max(playerCharacter.velocity.y - gravity * fall_multiplier * delta, -max_fall_speed)

		# Apply air drag
		var air_drag := 8.0
		desired_velocity.x = lerp(desired_velocity.x, 0.0, air_drag * delta)
		desired_velocity.z = lerp(desired_velocity.z, 0.0, air_drag * delta)

		return
	else:
		desired_velocity.y = 0.0

	if input_direction.length() > 0.01:
		owner.get_node('SkinnedMesh').look_at(owner.get_node('SkinnedMesh').global_transform.origin - input_direction, Vector3.UP)


# this is called by the pushy_crate when we bump into it
func lean_crate(crate: Node3D):
	# transition via the state machine
	Transitioned.emit("LeaningCrate", crate)


func _on_coyote_timer_timeout() -> void:
	in_coyote_time = false
