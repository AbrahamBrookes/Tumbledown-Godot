extends CharacterBody3D

class_name Pushable

## The Pushable component can be added to any CharacterBody3D derived node
## to allow it to be pushed. This could be a crate, which only moves a little
## or a log that rolls until it hits something.

# a reference to the state machine of the owner, for transitioning states
@export var state_machine: StateMachine = null

## How fast should this pushable (and the player) move when pushing?
@export var push_speed: float = 2.0

# in ready check configuration
func _ready():
	# the owner also needs a state machine to handle being pushed
	if not state_machine:
		push_error("Pushable component requires the owner to have a StateMachine node.")

	# and the state machine needs an "Idle" and "BeingPushed" state
	if not state_machine.has_state("BasicPushableIdle") or not state_machine.has_state("BasicPushableBeingPushed"):
		push_error("Pushable component requires the StateMachine to have 'BasicPushableIdle' and 'BasicPushableBeingPushed' states.")

# When we get pushed, switch states
func be_pushed(pushed_by: CharacterBody3D):
	state_machine.TransitionTo("BasicPushableBeingPushed")

# When we stop being pushed, simply turn off the flag
func stop_being_pushed():
	state_machine.TransitionTo("BasicPushableIdle")
