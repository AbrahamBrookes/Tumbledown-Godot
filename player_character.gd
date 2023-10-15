extends CharacterBody3D
class_name PlayerCharacter

@export var SPEED = 5.0
@export var LERP_SPEED = 0.35
@export var JUMP_VELOCITY = 4.5
@export var INVINCIBLE : bool = false

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

func slash():
	# stop all movement
	velocity = Vector3.ZERO

# called when we receive a hurt from somewhere
func hurt(amount:int, origin:Vector3, impulseMultiplier:int = 50):
	# only if we're not invincible
	if INVINCIBLE:
		return
	else:
		INVINCIBLE = true

	# stop all movement
	velocity = Vector3.ZERO

	# play hurt animation
	animTree.set("parameters/BlendSpace1D/blend_position", 0.0)
	# animTree.set("parameters/Hit", true)
	# animTree.set("parameters/Hit", false)

	print("hurt for " + str(amount) + " damage")
	
	# get the vector from the source to us
	var attackVector = global_transform.origin - origin
	# normalize it
	var normalizedAttackVector = attackVector.normalized()
	normalizedAttackVector.y = 0
	# apply impulse to player character
	velocity = normalizedAttackVector * impulseMultiplier
	move_and_slide()

	# flash the players visibility
	for n in 20:
		visible = !visible
		await get_tree().create_timer(0.05).timeout
	
	INVINCIBLE = false
	
