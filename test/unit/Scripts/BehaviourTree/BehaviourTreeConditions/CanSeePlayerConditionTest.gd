extends GutTest

class_name CanSeePlayerConditionTest

var behaviour_tree: BehaviourTree
var condition: CanSeePlayerCondition
var mock_owner: CharacterBody3D
var mock_head: Node3D
var mock_target: CharacterBody3D
var blackboard: Dictionary

func before_each():
	mock_owner = autoqfree(CharacterBody3D.new())
	behaviour_tree = autoqfree(BehaviourTree.new())
	condition = autoqfree(CanSeePlayerCondition.new())
	mock_head = autoqfree(Node3D.new())
	mock_target = autoqfree(CharacterBody3D.new())
	
	# Set up scene hierarchy
	behaviour_tree.add_child(condition)
	mock_owner.add_child(behaviour_tree)
	mock_owner.add_child(mock_head)
	add_child(mock_owner)
	add_child(mock_target)
	
	# Configure condition
	condition.head = mock_head
	condition.check_interval = 0.2
	condition.movement_threshold = 0.5
	condition.collision_mask = 1
	
	# Set up blackboard
	behaviour_tree.set_blackboard_value("owner", mock_owner)
	behaviour_tree.set_blackboard_value("target", mock_target)
	
	# Position entities
	mock_owner.global_position = Vector3.ZERO
	mock_head.global_position = Vector3.ZERO
	mock_target.global_position = Vector3(0, 0, 2)  # In front of head

## Test basic functionality
func test_returns_failure_when_no_target():
	behaviour_tree.set_blackboard_value("target", null)
	
	var result = condition.tick(behaviour_tree.blackboard)
	
	assert_eq(result, BehaviourTreeResult.Status.FAILURE)

func test_returns_failure_when_no_owner():
	behaviour_tree.set_blackboard_value("owner", null)
	
	var result = condition.tick(behaviour_tree.blackboard)
	
	assert_eq(result, BehaviourTreeResult.Status.FAILURE)

## Test field of view checks
func test_returns_failure_when_target_behind_head():
	# Position target behind the head
	mock_target.global_position = Vector3(0, 0, -2)  # Behind (negative Z)
	
	var result = condition.tick(behaviour_tree.blackboard)
	
	assert_eq(result, BehaviourTreeResult.Status.FAILURE)

func test_returns_success_when_target_in_front_with_clear_los():
	# Target in front, no obstacles
	mock_target.global_position = Vector3(0, 0, 2)
	
	var result = condition.tick(behaviour_tree.blackboard)
	
	assert_eq(result, BehaviourTreeResult.Status.SUCCESS)

func test_fov_check_with_angled_target():
	# Target at 45 degrees (should pass dot product > 0.5)
	mock_target.global_position = Vector3(1, 0, 1)
	
	var result = condition.tick(behaviour_tree.blackboard)
	
	assert_eq(result, BehaviourTreeResult.Status.SUCCESS)

func test_fov_check_fails_with_extreme_angle():
	# Target at 90 degrees (should fail dot product > 0.5)
	mock_target.global_position = Vector3(2, 0, 1)
	
	var result = condition.tick(behaviour_tree.blackboard)
	
	assert_eq(result, BehaviourTreeResult.Status.FAILURE)

## Test caching behavior
func test_caches_result_when_not_enough_time_passed():
	# First check should succeed
	mock_target.global_position = Vector3(0, 0, 2)
	var result1 = condition.tick(behaviour_tree.blackboard)
	assert_eq(result1, BehaviourTreeResult.Status.SUCCESS)
	
	# Move target behind head
	mock_target.global_position = Vector3(0, 0, -2)
	
	# Immediate second check should return cached result (SUCCESS)
	var result2 = condition.tick(behaviour_tree.blackboard)
	assert_eq(result2, BehaviourTreeResult.Status.SUCCESS)

func test_rechecks_after_time_interval():
	# First check
	mock_target.global_position = Vector3(0, 0, 2)
	var result1 = condition.tick(behaviour_tree.blackboard)
	assert_eq(result1, BehaviourTreeResult.Status.SUCCESS)
	
	# Move target behind head
	mock_target.global_position = Vector3(0, 0, -2)
	
	# Wait for check interval to pass
	await get_tree().create_timer(0.3).timeout
	
	# Should recheck and return new result
	var result2 = condition.tick(behaviour_tree.blackboard)
	assert_eq(result2, BehaviourTreeResult.Status.FAILURE)

## Test movement threshold
func test_caches_result_when_target_hasnt_moved_enough():
	# First check
	mock_target.global_position = Vector3(0, 0, 2)
	var result1 = condition.tick(behaviour_tree.blackboard)
	assert_eq(result1, BehaviourTreeResult.Status.SUCCESS)
	
	# Move target slightly (less than threshold)
	mock_target.global_position = Vector3(0.2, 0, 2)  # Moved 0.2 units
	
	# Wait for check interval to pass
	await get_tree().create_timer(0.3).timeout
	
	# Should return cached result even though target moved
	var result2 = condition.tick(behaviour_tree.blackboard)
	assert_eq(result2, BehaviourTreeResult.Status.SUCCESS)

func test_rechecks_when_target_moves_beyond_threshold():
	# First check
	mock_target.global_position = Vector3(0, 0, 2)
	var result1 = condition.tick(behaviour_tree.blackboard)
	assert_eq(result1, BehaviourTreeResult.Status.SUCCESS)
	
	# Move target significantly (more than threshold)
	mock_target.global_position = Vector3(1.0, 0, 2)  # Moved 1.0 units (> 0.5 threshold)
	
	# Wait for check interval to pass
	await get_tree().create_timer(0.3).timeout
	
	# Should recheck immediately
	var result2 = condition.tick(behaviour_tree.blackboard)
	assert_eq(result2, BehaviourTreeResult.Status.SUCCESS)  # Still visible

func test_rechecks_when_target_moves_to_different_side():
	# First check - target visible
	mock_target.global_position = Vector3(0, 0, 2)
	var result1 = condition.tick(behaviour_tree.blackboard)
	assert_eq(result1, BehaviourTreeResult.Status.SUCCESS)
	
	# Move target to behind head (beyond threshold)
	mock_target.global_position = Vector3(0, 0, -2)  # Moved 4 units (> 0.5 threshold)
	
	# Wait for check interval to pass
	await get_tree().create_timer(0.3).timeout
	
	# Should recheck and fail FOV test
	var result2 = condition.tick(behaviour_tree.blackboard)
	assert_eq(result2, BehaviourTreeResult.Status.FAILURE)

## Test raycast behavior with obstacles
func test_returns_failure_with_obstacle_blocking_view():
	# Create an obstacle between head and target
	var obstacle = autoqfree(StaticBody3D.new())
	var collision_shape = autoqfree(CollisionShape3D.new())
	var box_shape = BoxShape3D.new()
	
	collision_shape.shape = box_shape
	obstacle.add_child(collision_shape)
	
	# have to add the child to the scene before we can position it
	add_child(obstacle)

	obstacle.global_position = Vector3(0, 0, 2)  # Between head and target
	obstacle.collision_layer = 1  # On layer 1 (matches collision_mask)
	
	# Target behind obstacle
	mock_target.global_position = Vector3(0, 0, 4)
	
	# move the head up a touch so the ray will go through the obstacle
	mock_head.global_position = Vector3(0, 0.5, 0)
	
	var result = condition.tick(behaviour_tree.blackboard)
	
	assert_eq(result, BehaviourTreeResult.Status.FAILURE)

## Test configuration
func test_respects_custom_check_interval():
	condition.check_interval = 0.1  # Shorter interval
	
	mock_target.global_position = Vector3(0, 0, 2)
	condition.tick(behaviour_tree.blackboard)
	
	# Move target
	mock_target.global_position = Vector3(0, 0, -2)
	
	# Wait just past the shorter interval
	await get_tree().create_timer(0.15).timeout
	
	var result = condition.tick(behaviour_tree.blackboard)
	assert_eq(result, BehaviourTreeResult.Status.FAILURE)

func test_respects_custom_movement_threshold():
	condition.movement_threshold = 0.1  # Very sensitive to movement
	
	mock_target.global_position = Vector3(0, 0, 0.1)
	var result = condition.tick(behaviour_tree.blackboard)
	assert_eq(result, BehaviourTreeResult.Status.SUCCESS)
	
	# Small movement (should trigger recheck with lower threshold)
	mock_target.global_position = Vector3(0, 0, -0.1)
	
	# Wait for check interval to pass
	await get_tree().create_timer(0.3).timeout
	
	result = condition.tick(behaviour_tree.blackboard)
	# Should have rechecked (not returned cached result)
	assert_eq(result, BehaviourTreeResult.Status.FAILURE)
