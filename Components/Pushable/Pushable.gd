extends Node

class_name Pushable

## The Pushable component can be added to any CharacterBody3D derived node
## to allow it to be pushed. This could be a crate, which only moves a little
## or a log that rolls until it hits something.

# a reference to the state machine of the owner, for transitioning states
@export var state_machine: StateMachine = null

# Are we currently being pushed?
var is_being_pushed: bool = false

# which direction were being pushed in
var push_direction: Vector3 = Vector3.ZERO

# in ready check that the owner is a CharacterBody3D
func _ready():
	if not owner is CharacterBody3D:
		push_error("Pushable component can only be added to CharacterBody3D derived nodes.")

	# the owner also needs a state machine to handle being pushed
	if not owner.has_node("StateMachine"):
		push_error("Pushable component requires the owner to have a StateMachine node.")

	# and the state machine needs an "Idle" and "BeingPushed" state
	var state_machine = owner.get_node("StateMachine")
	if not state_machine.has_state("Idle") or not state_machine.has_state("BeingPushed"):
		push_error("Pushable component requires the StateMachine to have 'Idle' and 'BeingPushed' states.")
	
	# the being pushed state needs a reference to this component
	var being_pushed_state = state_machine.get_state("BeingPushed")
	being_pushed_state.pushable_component = self

# When we get pushed, switch states
func be_pushed(direction: Vector3):
	is_being_pushed = true
	push_direction = direction.normalized()
	state_machine.TransitionTo("BeingPushed", push_direction)

# When we stop being pushed, simply turn off the flag
func stop_being_pushed():
	is_being_pushed = false
	# the state has a reference to this component and it will handle the transition back to idle.
	# this allows the state to handle its own exit conditions ie a rolling log vs a scraping crate.
