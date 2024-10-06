extends CharacterBody3D

var navigation_target: Vector3 = Vector3.ZERO

@export var idle_state: Leech_Idle

# Called when the node enters the scene tree for the first time.
func _ready():
	$StateMachine.TransitionTo("leech_locomote")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_sight_entered(other):
	# if something I can suck the blood of enters my scene of vision
	if other.has_method('hurt'):
		## if we are not idle, we can't pursue
		#if not $StateMachine.current_state == idle_state:
		#	print($StateMachine)
		#	return
		
		# pursue them!
		$StateMachine.TransitionTo('leech_pursue', {
			target = other
		})

