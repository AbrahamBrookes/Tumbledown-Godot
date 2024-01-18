extends State
class_name Locomote

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var mass = 10.0

@export var SPEED = 5.0
@export var LERP_SPEED = 0.35

func Enter(extra_data = null):
	stateMachine.travel("Locomote")


func Exit():
	pass


func Update(_delta: float):
	pass


func Physics_Update(_delta: float):
	# Add the gravity.
	if not playerCharacter.is_on_floor():
		playerCharacter.velocity.y -= gravity * _delta * mass

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("walk_west", "walk_east", "walk_north", "walk_south")
	
	if input_dir:
		playerCharacter.velocity.x = lerp(playerCharacter.velocity.x, input_dir.x * SPEED, LERP_SPEED)
		playerCharacter.velocity.z = lerp(playerCharacter.velocity.z, input_dir.y * SPEED, LERP_SPEED)
		
		# rotate to face direction
		## add the direction to the current position
		var lookat_location = playerCharacter.global_transform.origin + Vector3(input_dir.x, 0, input_dir.y)
		## lookat that location
		playerCharacter.look_at(lookat_location, Vector3.UP)
	else:
		playerCharacter.velocity.x = lerp(playerCharacter.velocity.x, 0.0, LERP_SPEED)
		playerCharacter.velocity.z = lerp(playerCharacter.velocity.z, 0.0, LERP_SPEED)
	
	animTree.set("parameters/StateMachine/Locomote/blend_position", playerCharacter.velocity.length() / SPEED)

