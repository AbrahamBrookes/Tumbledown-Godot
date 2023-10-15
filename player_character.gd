class_name PlayerCharacter
extends CharacterBody3D

@export var SPEED = 5.0
@export var LERP_SPEED = 0.35
@export var JUMP_VELOCITY = 4.5

@onready var animTree = $"kora_toon/Locomote"

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	# if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	# 	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("walk_west", "walk_east", "walk_north", "walk_south")
	
	if input_dir:
		velocity.x = lerp(velocity.x, input_dir.x * SPEED, LERP_SPEED)
		velocity.z = lerp(velocity.z, input_dir.y * SPEED, LERP_SPEED)
		
		# rotate to face direction
		## add the direction to the current position
		var lookat_location = global_transform.origin + Vector3(input_dir.x, 0, input_dir.y)
		## lookat that location
		look_at(lookat_location, Vector3.UP)
	else:
		velocity.x = lerp(velocity.x, 0.0, LERP_SPEED)
		velocity.z = lerp(velocity.z, 0.0, LERP_SPEED)
		
	animTree.set("parameters/BlendSpace1D/blend_position", velocity.length() / SPEED)
	
	move_and_slide()
