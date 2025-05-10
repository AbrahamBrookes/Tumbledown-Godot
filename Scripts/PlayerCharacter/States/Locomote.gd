extends State
class_name Locomote

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var mass = 10.0

@export var SPEED = 5.0
@export var LERP_SPEED = 0.35

var can_slash = true

func Enter(extra_data = null):
	owner.animTree.set("parameters/AnimSpeed/scale", 2.0)

func Exit():
	pass


func Update(_delta: float):
	pass


func Physics_Update(_delta: float):
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
	
	input_walk()

func input_walk():
	
	if not owner.get_node('GroundCast').is_colliding():
		return
	
	var input_dir = Input.get_vector("walk_west", "walk_east", "walk_north", "walk_south")
	var input_direction = Vector3(
		Input.get_action_strength("walk_east") - Input.get_action_strength("walk_west"),
		0,
		Input.get_action_strength("walk_south") - Input.get_action_strength("walk_north")
	)

	input_direction = input_direction.normalized() * playerCharacter.move_speed
	
	if input_direction == Vector3.ZERO:
		return
	
	playerCharacter.apply_central_force(input_direction * playerCharacter.move_speed * 40)
	
	# rotate $SkinnedMesh to face the direction of movement
	if input_direction != Vector3.ZERO:
		owner.get_node('SkinnedMesh').look_at(owner.get_node('SkinnedMesh').global_transform.origin - input_direction, Vector3.UP)

# this is called by the pushy_crate when we bump into it
func lean_crate(crate: Node3D):
	# transition via the state machine
	Transitioned.emit("LeaningCrate", crate)
