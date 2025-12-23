extends Node

class_name CratePusher

## The CratePusher is a component that can be added to any Actor (or the player)
## in order to allow them to push crates. This does rely on the StateMachine
## on the Actor having the `PushingCrate` state.

# the raycast3D node that will detect collision with pushables
@onready var ray : RayCast3D = $ray

# a reference to the state machine on the parent actor, for querying and setting state
@export var state_machine: StateMachine

# some hysteresis to avoid flickering between pushing and not pushing
@export var push_threshold: float = 0.2
var threshold_timer: float = 0.0

# on ready, check the state machine has the states we need
func _ready():
	if not state_machine:
		push_error("CratePusher: No state machine assigned!")
		return
	
	if not state_machine.has_state("PushingPushable"):
		push_warning("CratePusher: StateMachine has no 'PushingPushable' state! Crate pushing will not work.")

	if not state_machine.has_state("Locomote"):
		push_warning("CratePusher: StateMachine has no 'Locomote' state! Crate pushing will not exit correctly.")

# when the ray intersects with a pushable, emit start_pushing
func _physics_process(_delta):
		
	var input_direction = Vector3(
		Input.get_action_strength("walk_east") - Input.get_action_strength("walk_west"),
		0,
		Input.get_action_strength("walk_south") - Input.get_action_strength("walk_north")
	)

	if input_direction == Vector3.ZERO:
		state_machine.TransitionTo("Locomote")

	# if the player is pressing towards a pushable, start pushing
	if ray.is_colliding():
		var collider = ray.get_collider()

		# early return if we're not going to be pushing
		if not collider or not collider.has_method("be_pushed"):
			# reset the threshold timer
			threshold_timer = 0.0
			return

		# increment the threshold timer to avoid flickering
		threshold_timer += _delta
		if threshold_timer >= push_threshold:
			state_machine.TransitionTo("PushingPushable", collider)
	else:
		# reset the threshold timer
		threshold_timer = 0.0
	
