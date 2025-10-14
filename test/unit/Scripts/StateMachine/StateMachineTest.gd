extends GutTest

var state_machine: StateMachine
var anim_tree: AnimationTree
var playback_double: AnimationNodeStateMachinePlayback
var anim_state_machine: AnimationNodeStateMachine
var idle_state: State
var walk_state: State


func before_each():
	# Setup the state machine
	state_machine = autoqfree(StateMachine.new())

	# our animtree's state machine must be configured with an animation state machine
	anim_tree = double(AnimationTree).new()
	# assign the anim tree to the state machine
	state_machine.animTree = anim_tree

	# give it some states
	idle_state = autoqfree(State.new())
	idle_state.name = "Idle"
	walk_state = autoqfree(State.new())
	walk_state.name = "Walk"
	state_machine.initial_state = idle_state

	add_child(state_machine)


## Our script needs an anim tree reference set in the editor or it will throw an error
func test_if_the_state_machine_has_no_anim_tree_it_will_throw_an_error():
	# clear the anim tree reference
	state_machine.animTree = null
	# ready up the state machine
	state_machine._ready()
	# Expect our script to throw an error
	assert_push_error("StateMachine: AnimationTree not assigned!")


## Our script needs an initial state set in the editor or it will throw an error
func test_if_the_state_machine_has_no_initial_state_it_will_throw_an_error():
	# clear the initial state reference
	state_machine.initial_state = null
	# ready up the state machine
	state_machine._ready()
	# Expect our script to throw an error
	assert_push_error("StateMachine: initial_state not assigned!")


## If there are State objects as children of the StateMachine they are auto-registered
func test_the_state_machine_registers_child_states_on_ready():
	# add our states as children of the state machine
	state_machine.add_child(idle_state)
	state_machine.add_child(walk_state)
	# ready up the state machine
	state_machine._ready()
	# Expect our states to be registered
	assert_eq(state_machine.states.size(), 2)
	# states names are lower cased before saving them as a key
	assert_true(state_machine.states.has("idle"))
	assert_true(state_machine.states.has("walk"))


## We are able to transition between states by calling the TransitionTo method
func test_the_state_machine_can_transition_between_states():
	# add our states as children of the state machine
	state_machine.add_child(idle_state)
	state_machine.add_child(walk_state)
	# ready up the state machine
	state_machine._ready()
	# transition to the walk state
	state_machine.TransitionTo("Walk")
	# Expect our current state to be the walk state
	assert_eq(state_machine.current_state.name, "Walk")
	assert_eq(state_machine.previous_state.name, "Idle")


## When the StateMachine registers child states it also links their Transitioned signal
## to its own TransitionTo method
func test_the_state_machine_can_transition_between_states_via_signal():
	# add our states as children of the state machine
	state_machine.add_child(idle_state)
	state_machine.add_child(walk_state)
	# ready up the state machine
	state_machine._ready()
	# emit the Transitioned signal from the idle state
	idle_state.emit_signal("Transitioned", "Walk")
	# Expect our current state to be the walk state
	assert_eq(state_machine.current_state.name, "Walk")
	assert_eq(state_machine.previous_state.name, "Idle")


## Every frame the StateMachine calls its current states Update method
func test_the_state_machine_calls_update_on_current_state():
	# mock the idle state so we can spy on it as a double
	idle_state = double(State).new()
	state_machine.add_child(idle_state)
	# add our states as children of the state machine
	state_machine.initial_state = idle_state
	# ready up the state machine
	state_machine._ready()
	# call the state machine's _process method
	state_machine._process(0.016)
	# Expect the idle state's Update method to have been called
	assert_called(idle_state, "Update")


## Every physics frame the StateMachine calls its current states Physics_Update method
func test_the_state_machine_calls_physics_update_on_current_state():
	# mock the idle state so we can spy on it as a double
	idle_state = double(State).new()
	state_machine.add_child(idle_state)
	# add our states as children of the state machine
	state_machine.initial_state = idle_state
	# ready up the state machine
	state_machine._ready()
	# call the state machine's _physics_process method
	state_machine._physics_process(0.016)
	# Expect the idle state's Physics_Update method to have been called
	assert_called(idle_state, "Physics_Update")


## When the StateMachine transitions to a new state it calls the Enter method of that state
func test_the_state_machine_calls_enter_on_new_state():
	# mock the walk state so we can spy on it as a double
	walk_state = double(State).new()
	walk_state.name = "Walk"
	state_machine.add_child(walk_state)
	# add our states as children of the state machine
	state_machine.add_child(idle_state)
	state_machine.initial_state = idle_state
	# ready up the state machine
	state_machine._ready()
	# transition to the walk state
	state_machine.TransitionTo("Walk")
	# Expect the walk state's Enter method to have been called
	assert_called(walk_state, "Enter")


## When the StateMachine transitions away from a state it calls the Exit method of that state
func test_the_state_machine_calls_exit_on_old_state():
	# mock the idle state so we can spy on it as a double
	idle_state = double(State).new()
	idle_state.name = "Idle"
	state_machine.add_child(idle_state)
	# add our states as children of the state machine
	state_machine.add_child(walk_state)
	state_machine.initial_state = idle_state
	# ready up the state machine
	state_machine._ready()
	# transition to the walk state
	state_machine.TransitionTo("Walk")
	# Expect the idle state's Exit method to have been called
	assert_called(idle_state, "Exit")
