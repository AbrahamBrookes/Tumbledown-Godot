extends CharacterBody3D
class_name PlayerCharacter

@export var SPEED = 5.0
@export var LERP_SPEED = 0.35
@export var JUMP_VELOCITY = 4.5
@export var INVINCIBLE : bool = false

@onready var animTree = $"SkinnedMesh/AnimationTree"
@onready var stateMachine = $"StateMachine"

var startedSlashingAt

func _ready():
	stateMachine.TransitionTo("Locomote")

func _process(delta):
	if Input.is_action_just_pressed("slash"):
		slash()

func _physics_process(delta):
	move_and_slide()
	for i in get_slide_collision_count():
		var collider = get_slide_collision(i).get_collider()
		if(collider.has_method('push')):
			stateMachine.TransitionTo("LeaningCrate", collider)

func can_slash():
	# if we are not currently slashing
	if stateMachine.current_state is Slash:
		return false
		
	return true

func slash():
	if(!can_slash()):
		return
	
	stateMachine.TransitionTo("Slash")

func can_crouch():
	# return stateMachine.current_state is Locomote
	pass

func crouch():
	if(!can_crouch()):
		return
	
	stateMachine.TransitionTo("Crouch")
	

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

	# flash the players visibility
	for n in 20:
		visible = !visible
		await get_tree().create_timer(0.05).timeout
	
	INVINCIBLE = false
	
