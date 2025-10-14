extends Node3D
class_name StateMachine

@export var animTree : AnimationTree
# playback is the engine-level animation tree state machine
@onready var playback = animTree.get("parameters/StateMachine/playback")
# the state to start on, set in the editor
@export var initial_state: State
# debug if ya wanna
@export var debug_mode: bool = false

var states : Dictionary = {}
var current_state : State
var previous_state : State

func _ready():
	# protect against misconfiguration
	if not animTree:
		push_error("StateMachine: AnimationTree not assigned!")
		return
	
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(TransitionTo)
			# child states need a reference to the state machine
			child.state_machine = self

	if debug_mode:
		print("StateMachine: states loaded: ", states.keys())
	
	if initial_state:
		TransitionTo(initial_state.name)
	else:
		push_error("StateMachine: initial_state not assigned!")


func _process(delta):
	if current_state:
		current_state.Update(delta)


func _physics_process(delta):
	if current_state:
		current_state.Physics_Update(delta)


func TransitionTo(new_state_name: String, extra_data = null) -> bool:
	var new_state = states.get(new_state_name.to_lower())
	if not new_state:
		push_error("State " + new_state_name + " not found. Available: " + str(states.keys()))
		return false

	# Prevent transitioning to same state unless explicitly allowed
	if current_state == new_state and not new_state.allow_self_transition:
		return false

	if debug_mode:
		print("Transitioning: ", current_state.name if current_state else "None", " -> ", new_state_name)
	
	previous_state = current_state
	
	if current_state:
		current_state.Exit()
	
	playback.travel(new_state_name)

	new_state.Enter(extra_data)
	
	current_state = new_state

	return true

# an alias for TransitionTo
func travel(new_state_name, extra_data = null):
	TransitionTo(new_state_name, extra_data)

