extends CharacterBody3D

class_name Pushable

## The Pushable component can be added to any CharacterBody3D derived node
## to allow it to be pushed. This could be a crate, which only moves a little
## or a log that rolls until it hits something.

# a reference to the state machine of the owner, for transitioning states
@export var state_machine: StateMachine = null

## How fast should this pushable (and the player) move when pushing?
@export var push_speed: float = 2.0

## Should this pushable stop moving if the player stops pushing it?
@export var should_stop_immediately: bool = true

## allow inheriting classes to shunt in their own states
@export var rolling_state_name: String = "BeingPushed"
@export var idle_state_name: String = "Idle"

# in ready check configuration
func _ready():
	# the owner also needs a state machine to handle being pushed
	if not state_machine:
		push_error("Pushable component requires the owner to have a StateMachine node.")

	# and the state machine needs an "Idle" and "BeingPushed" state
	if not state_machine.has_state(idle_state_name) \
	or not state_machine.has_state(rolling_state_name):
		push_warning("Pushable component requires the StateMachine to have '%s' and '%s' states." % [idle_state_name, rolling_state_name])

func can_be_pushed() -> bool:
	return state_machine.current_state.has_method('be_pushed')
	
# When we get pushed, switch states
func be_pushed(_pushed_by: CharacterBody3D):
	# defer to current state so it can handle that
	if state_machine.current_state.has_method('be_pushed'):
		state_machine.current_state.be_pushed()

# When we stop being pushed, simply turn off the flag
func stop_being_pushed():
	if should_stop_immediately:
		state_machine.TransitionTo(idle_state_name)

# When this pushable gets pushed into water it should land and float
func _on_wettable_fell_in_water() -> void:
	$SplashParticle.splash(global_position)
	
	# perhaps we want a "should_float" flag here
	state_machine.travel("Float")
