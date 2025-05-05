extends RigidBody3D
class_name PlayerCharacter

@export var SPEED = 5.0
@export var LERP_SPEED = 0.35
@export var JUMP_VELOCITY = 4.5
@export var INVINCIBLE : bool = false

@export var animTree : AnimationTree
@onready var stateMachine = $StateMachine

func _ready():
	stateMachine.TransitionTo("Locomote")

func _process(delta):
	pass

@export var move_speed = 15



#	# Get the input direction and handle the movement/deceleration.
#	var input_dir = Input.get_vector("walk_west", "walk_east", "walk_north", "walk_south")
#	
#	if input_dir:
#		playerCharacter.velocity.x = lerp(playerCharacter.velocity.x, input_dir.x * SPEED, LERP_SPEED)
#		playerCharacter.velocity.z = lerp(playerCharacter.velocity.z, input_dir.y * SPEED, LERP_SPEED)
#		
#		# rotate to face direction
#		## add the direction to the current position
#		var lookat_location = playerCharacter.global_transform.origin + Vector3(input_dir.x, 0, input_dir.y)
#		## lookat that location
#		playerCharacter.look_at(lookat_location, Vector3.UP)
#	else:
#		playerCharacter.velocity.x = lerp(playerCharacter.velocity.x, 0.0, LERP_SPEED)
#		playerCharacter.velocity.z = lerp(playerCharacter.velocity.z, 0.0, LERP_SPEED)
#	
#	animTree.set("parameters/StateMachine/Locomote/blend_position", playerCharacter.velocity.length() / SPEED)
#	
#	
#	for i in playerCharacter.get_slide_collision_count():
#		var collider = playerCharacter.get_slide_collision(i).get_collider()
#		if(collider.has_method('push')):
#			# only if we are pushing towards a cardinal direction (no diagonals)
#			var input = Input.get_vector("walk_west", "walk_east", "walk_north", "walk_south").round()
#			# one of the values in the vector must be zero
#			if input.x == 0 or input.y == 0 and input != Vector2.ZERO:
#				get_parent().TransitionTo("LeaningCrate", collider)

func _physics_process(state):
	
	linear_damp = 25
	gravity_scale = 1
	if not $GroundCast.is_colliding():
		linear_damp = 0
		gravity_scale = 10

	# update the animation tree with the real velocity
	animTree.set("parameters/StateMachine/Locomote/blend_position", linear_velocity.length() / SPEED)
	

# called when we receive a hurt from somewhere
func receive_damage(damage:Damage):
	# only if we're not invincible
	if INVINCIBLE:
		return
	else:
		INVINCIBLE = true

	# stop all movement
#	velocity = Vector3.ZERO

	# play hurt animation
	animTree.set("parameters/BlendSpace1D/blend_position", 0.0)
	# animTree.set("parameters/Hit", true)
	# animTree.set("parameters/Hit", false)

	print("hurasdasdast for " + str(damage.amount) + " damage")
	
	# get the vector from the source to us
	var attackVector = global_transform.origin - damage.source.global_transform.origin
	# normalize it
	var normalizedAttackVector = attackVector.normalized()
	normalizedAttackVector.y = 0
	# apply impulse to player character
	apply_impulse(normalizedAttackVector * 4000)

	# flash the players visibility
	for n in 20:
		visible = !visible
		await get_tree().create_timer(0.05).timeout
	
	INVINCIBLE = false
