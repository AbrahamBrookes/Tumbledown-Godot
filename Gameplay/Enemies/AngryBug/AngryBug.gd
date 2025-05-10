extends RigidBody3D
class_name AngryBug

@onready var stateMachine = $StateMachine
@export var INVINCIBLE : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	stateMachine.TransitionTo("AngryBugLocomote")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# called when we receive a hurt from somewhere
func receive_damage(damage:Damage):
	# only if we're not invincible
	if INVINCIBLE:
		return
	else:
		INVINCIBLE = true

	# stop all movement
#	velocity = Vector3.ZERO
	
	# get the vector from the source to us
	var attackVector = global_transform.origin - damage.source.global_transform.origin
	# normalize it
	var normalizedAttackVector = attackVector.normalized()
	normalizedAttackVector.y = 0
	# apply impulse to player character
	apply_impulse(normalizedAttackVector * 3500)

	# flash the players visibility
	for n in 20:
		visible = !visible
		await get_tree().create_timer(0.05).timeout
	
	INVINCIBLE = false


