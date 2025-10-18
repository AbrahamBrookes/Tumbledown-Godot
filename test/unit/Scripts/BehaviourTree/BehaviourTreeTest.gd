extends GutTest

class_name BehaviourTreeTest

var blackboard: BehaviourTreeBlackboard
var behavior_tree: BehaviourTree
var root_selector: BehaviourTreeSelector
var state_machine: StateMachine

func before_each():
	blackboard = autoqfree(BehaviourTreeBlackboard.new())
	behavior_tree = autoqfree(BehaviourTree.new())
	root_selector = autoqfree(BehaviourTreeSelector.new())
	state_machine = autofree(StateMachine.new())
	
	behavior_tree.blackboard = blackboard
	behavior_tree.state_machine = state_machine
	behavior_tree.add_child(root_selector)

func after_each():
	behavior_tree = null
	root_selector = null

## Test basic behavior tree execution
func test_behavior_tree_executes_root_node():
	var mock_action = MockAction.new()
	mock_action.return_value = BehaviourTreeResult.Status.SUCCESS
	root_selector.add_child(mock_action)
	# we need to add the behaviour tree to the scene _after_ setting up its child
	# nodes as it caches them in _ready
	add_child(behavior_tree)
	
	var result = behavior_tree.tick()
	
	assert_true(mock_action.was_ticked, "Action should have been ticked")

## Test selector chooses first successful child
func test_selector_returns_first_success():
	var failing_action = MockAction.new()
	failing_action.return_value = BehaviourTreeResult.Status.FAILURE
	
	var succeeding_action = MockAction.new()
	succeeding_action.return_value = BehaviourTreeResult.Status.SUCCESS
	
	var never_called_action = MockAction.new()
	never_called_action.return_value = BehaviourTreeResult.Status.SUCCESS
	
	root_selector.add_child(failing_action)
	root_selector.add_child(succeeding_action)
	root_selector.add_child(never_called_action)
	add_child(behavior_tree)
	
	var result = behavior_tree.tick()
	
	assert_eq(result, BehaviourTreeResult.Status.SUCCESS)
	assert_true(failing_action.was_ticked, "First action should be tried")
	assert_true(succeeding_action.was_ticked, "Second action should be tried")
	assert_false(never_called_action.was_ticked, "Third action should not be called")

## Test selector fails when all children fail
func test_selector_fails_when_all_children_fail():
	var failing_action1 = MockAction.new()
	failing_action1.return_value = BehaviourTreeResult.Status.FAILURE
	
	var failing_action2 = MockAction.new()
	failing_action2.return_value = BehaviourTreeResult.Status.FAILURE
	
	root_selector.add_child(failing_action1)
	root_selector.add_child(failing_action2)
	add_child(behavior_tree)
	
	var result = behavior_tree.tick()
	
	assert_eq(result, BehaviourTreeResult.Status.FAILURE)
	assert_true(failing_action1.was_ticked)
	assert_true(failing_action2.was_ticked)

## Test sequence requires all children to succeed
func test_sequence_requires_all_children_to_succeed():
	var sequence = autoqfree(BehaviourTreeSequence.new())
	
	var condition = MockCondition.new()
	condition.return_value = BehaviourTreeResult.Status.SUCCESS
	
	var action = MockAction.new()
	action.return_value = BehaviourTreeResult.Status.SUCCESS
	
	sequence.add_child(condition)
	sequence.add_child(action)
	root_selector.add_child(sequence)
	add_child(behavior_tree)
	
	var result = behavior_tree.tick()
	
	assert_eq(result, BehaviourTreeResult.Status.SUCCESS)
	assert_true(condition.was_ticked, "Condition should be checked")
	assert_true(action.was_ticked, "Action should be executed")

## Test sequence fails on first failure
func test_sequence_fails_on_first_failure():
	var sequence = autoqfree(BehaviourTreeSequence.new())
	
	var failing_condition = MockCondition.new()
	failing_condition.return_value = BehaviourTreeResult.Status.FAILURE
	
	var never_called_action = MockAction.new()
	never_called_action.return_value = BehaviourTreeResult.Status.SUCCESS
	
	sequence.add_child(failing_condition)
	sequence.add_child(never_called_action)
	root_selector.add_child(sequence)
	add_child(behavior_tree)
	
	var result = behavior_tree.tick()
	
	assert_eq(result, BehaviourTreeResult.Status.FAILURE)
	assert_true(failing_condition.was_ticked, "Condition should be checked")
	assert_false(never_called_action.was_ticked, "Action should not be called")

## Test running state propagation
func test_running_state_propagates_correctly():
	var sequence = autoqfree(BehaviourTreeSequence.new())
	
	var condition = MockCondition.new()
	condition.return_value = BehaviourTreeResult.Status.SUCCESS
	
	var running_action = MockAction.new()
	running_action.return_value = BehaviourTreeResult.Status.RUNNING
	
	sequence.add_child(condition)
	sequence.add_child(running_action)
	root_selector.add_child(sequence)
	add_child(behavior_tree)
	
	var result = behavior_tree.tick()
	
	assert_eq(result, BehaviourTreeResult.Status.RUNNING)
	assert_true(condition.was_ticked)
	assert_true(running_action.was_ticked)

## Test blackboard data sharing
func test_blackboard_data_sharing():
	behavior_tree.set_blackboard_value("test_key", "test_value")
	behavior_tree.set_blackboard_value("health", 75)
	
	var blackboard_reader = BlackboardReaderAction.new()
	root_selector.add_child(blackboard_reader)
	add_child(behavior_tree)
	
	var result = behavior_tree.tick()
	
	assert_eq(result, BehaviourTreeResult.Status.SUCCESS)
	assert_eq(blackboard_reader.read_value, "test_value")
	assert_eq(blackboard_reader.health_value, 75)

## Test complex nested structure
func test_complex_nested_behavior_tree():
	# Root selector with two main branches
	
	# Branch 1: Combat sequence (high priority)
	var combat_sequence = autoqfree(BehaviourTreeSequence.new())
	var enemy_in_range = MockCondition.new()
	enemy_in_range.return_value = BehaviourTreeResult.Status.FAILURE  # No enemy in range
	var attack_action = MockAction.new()
	attack_action.return_value = BehaviourTreeResult.Status.SUCCESS
	
	combat_sequence.add_child(enemy_in_range)
	combat_sequence.add_child(attack_action)
	
	# Branch 2: Patrol sequence (fallback)
	var patrol_sequence = autoqfree(BehaviourTreeSequence.new())
	var not_at_waypoint = MockCondition.new()
	not_at_waypoint.return_value = BehaviourTreeResult.Status.SUCCESS
	var move_to_waypoint = MockAction.new()
	move_to_waypoint.return_value = BehaviourTreeResult.Status.SUCCESS
	
	patrol_sequence.add_child(not_at_waypoint)
	patrol_sequence.add_child(move_to_waypoint)
	
	root_selector.add_child(combat_sequence)
	root_selector.add_child(patrol_sequence)
	add_child(behavior_tree)
	
	var result = behavior_tree.tick()
	
	assert_eq(result, BehaviourTreeResult.Status.SUCCESS)
	# Combat should fail, so patrol should execute
	assert_true(enemy_in_range.was_ticked)
	assert_false(attack_action.was_ticked)  # Combat sequence failed early
	assert_true(not_at_waypoint.was_ticked)
	assert_true(move_to_waypoint.was_ticked)
