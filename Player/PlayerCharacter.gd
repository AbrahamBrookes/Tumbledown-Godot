extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@export var INVINCIBLE : bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


# called when we receive a hurt from somewhere
func receive_damage(damage:Damage):
	print("hurt for " + str(damage.amount) + " damage")
	# only if we're not invincible
	if INVINCIBLE:
		return
	else:
		INVINCIBLE = true

	# stop all movement
#	velocity = Vector3.ZERO

	# play hurt animation
	# animTree.set("parameters/BlendSpace1D/blend_position", 0.0)
	# animTree.set("parameters/Hit", true)
	# animTree.set("parameters/Hit", false)

	
	# get the vector from the source to us
	var attackVector = global_transform.origin - damage.source.position
	# normalize it
	var normalizedAttackVector = attackVector.normalized()
	normalizedAttackVector.y = 0
	# apply impulse to player character
#	velocity = normalizedAttackVector * impulseMultiplier

	# flash the players visibility
	for n in 20:
		visible = !visible
		await get_tree().create_timer(0.05).timeout
	
	INVINCIBLE = false
	

