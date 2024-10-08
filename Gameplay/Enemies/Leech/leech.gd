extends RigidBody3D

var navigation_target: Vector3 = Vector3.ZERO

@export var idle_state: Leech_Idle

@export var health: int = 5

# a list of all the things in sight that we can hurt
var pursueable_enemies: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$StateMachine.TransitionTo("leech_locomote")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(state):
	
	linear_damp = 25
	gravity_scale = 1
	if not $GroundCast.is_colliding():
		linear_damp = 0
		gravity_scale = 10

func _on_sight_entered(other):
	# if something I can suck the blood of enters my scene of vision
	if other.has_method('hurt'):
		# add it to my hittables array
		pursueable_enemies.append(other)

func _on_sight_exited(other):
	# remove from my hittables array
	pursueable_enemies.erase(other)
	
	# if we can't see any enemies, go back to idle
	if pursueable_enemies.size() == 0:
		$StateMachine.TransitionTo('leech_idle')

# called when we receive a hurt from somewhere
func hurt(amount:int, origin:Vector3, impulseMultiplier:int = 50):

	health -= amount
	if health <= 0:
		queue_free()
		return
		
	# only if we're not invincible

	# play hurt animation
	
	$StateMachine.TransitionTo('leech_hurt', {
		amount = amount,
		origin = origin,
		impulseMultiplier = impulseMultiplier
	})

func _on_too_close_attack_box_body_entered(other):
		if other.has_method('hurt'):
			other.hurt(1, global_position)
