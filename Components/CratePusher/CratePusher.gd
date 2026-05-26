extends Node

class_name CratePusher

## The CratePusher is a component that can be added to any Actor (or the player)
## in order to allow them to push crates. This does rely on the StateMachine
## on the Actor having the `PushingPushable` state.

# the raycast3D node that will detect collision with pushables
@export var ray : RayCast3D

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
	# only allow pushing from locomote state
	if not state_machine.is_in_states(["Locomote"]):
		return
	
	# early return if the ray isn't colliding
	if not ray.is_colliding():
		state_machine.travel("Locomote")
		return
	
	var collider = ray.get_collider()
	if not collider: return

	# early return if we're not pushing into a pushable
	if not collider.has_method('can_be_pushed'):
		return

	if not collider.can_be_pushed():
		return

	# otherwise we're good to push!
	state_machine.TransitionTo("LeaningPushable", collider)
