extends State
class_name Locomote

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var LERP_SPEED = 0.35
@export var acceleration := 10.0
var target_velocity := Vector3.ZERO

var can_slash = true

func Enter(extra_data = null):
	owner.animTree.set("parameters/AnimSpeed/scale", 3.0)


func Exit():
	pass


func Update(_delta: float):
	pass


func Physics_Update(delta: float):
	# if the player presses crouch, crouch
	if Input.is_action_just_pressed('crouch'):
		Transitioned.emit('Crouching')
		return

	# if the player presses slash, slash
	if Input.is_action_just_pressed("slash"):
		Transitioned.emit("Slash")
		return

	# if the player presses jump, jump
	if Input.is_action_just_pressed("jump"):
		if owner.get_node('GroundCast').is_colliding():
			Transitioned.emit("Jumping")
			return
	
	input_walk(delta)


func input_walk(delta: float):
	# update the animation tree with the real velocity
	state_machine.animTree.set("parameters/StateMachine/Locomote/blend_position", playerCharacter.velocity.length() / playerCharacter.move_speed)
	
	var input_dir = Input.get_vector("walk_west", "walk_east", "walk_north", "walk_south")
	var input_direction = Vector3(
		Input.get_action_strength("walk_east") - Input.get_action_strength("walk_west"),
		0,
		Input.get_action_strength("walk_south") - Input.get_action_strength("walk_north")
	)

	input_direction = input_direction.normalized() * playerCharacter.move_speed
	
	# Convert input to world direction
	#move_dir = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if not playerCharacter.is_on_floor():
		var fall_multiplier := 3.5
		var max_fall_speed := 50.0  # tweak this

		# Apply gravity
		playerCharacter.velocity.y = max(playerCharacter.velocity.y - gravity * fall_multiplier * delta, -max_fall_speed)

		# Apply air drag
		var air_drag := 8.0
		playerCharacter.velocity.x = lerp(playerCharacter.velocity.x, 0.0, air_drag * delta)
		playerCharacter.velocity.z = lerp(playerCharacter.velocity.z, 0.0, air_drag * delta)

		playerCharacter.move_and_slide()
		return
	
	
	if input_direction.length() > 0.01:
		# Rotate toward movement direction (top-down, yaw only)
		owner.get_node('SkinnedMesh').look_at(owner.get_node('SkinnedMesh').global_transform.origin - input_direction, Vector3.UP)

	playerCharacter.velocity.x = input_direction.x
	playerCharacter.velocity.z = input_direction.z
	playerCharacter.move_and_slide()


# this is called by the pushy_crate when we bump into it
func lean_crate(crate: Node3D):
	# transition via the state machine
	Transitioned.emit("LeaningCrate", crate)
