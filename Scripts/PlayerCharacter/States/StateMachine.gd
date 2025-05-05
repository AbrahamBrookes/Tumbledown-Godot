extends Node3D
class_name StateMachine

@export var animTree : AnimationTree
# playback is the engine-level animation tree state machine
@onready var playback = animTree.get("parameters/StateMachine/playback")

@export var initial_state: State

var states : Dictionary = {}
var current_state : State

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(TransitionTo)
	
	if(initial_state):
		initial_state.Enter()
		current_state = initial_state

func _process(delta):
	if(current_state):
		current_state.Update(delta)
	
func _physics_process(delta):
	if(current_state):
		current_state.Physics_Update(delta)

func TransitionTo(new_state_name, extra_data = null):
	var new_state = states.get(new_state_name.to_lower())
	if(!new_state):
		push_error("state " + new_state_name + " not found")
		return
	playback.travel(new_state_name)
	
	if(current_state):
		current_state.Exit()
	
	new_state.Enter(extra_data)
	
	current_state = new_state
	print(new_state_name)

# an alias for TransitionTo
func travel(new_state_name, extra_data = null):
	TransitionTo(new_state_name, extra_data)

