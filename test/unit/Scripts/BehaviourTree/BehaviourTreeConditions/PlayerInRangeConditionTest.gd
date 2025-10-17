extends GutTest

class_name PlayerInRangeConditionTest

var condition: PlayerInRangeCondition
var mock_owner: CharacterBody3D
var mock_player: CharacterBody3D
var behaviour_tree: BehaviourTree

func before_each():
	condition = autoqfree(PlayerInRangeCondition.new())
	mock_owner = autoqfree(CharacterBody3D.new())
	mock_player = autoqfree(CharacterBody3D.new())
	behaviour_tree = autoqfree(BehaviourTree.new())
	
	# Add to scene tree
	add_child(mock_owner)
	add_child(mock_player)

	mock_owner.add_child(behaviour_tree)
	behaviour_tree.add_child(condition)
	
	# Set default range
	condition.range = 5.0

	# Set up blackboard
	behaviour_tree.set_blackboard_value("owner", mock_owner)
	behaviour_tree.set_blackboard_value("player", mock_player)
	
	# Default positions
	mock_owner.global_position = Vector3.ZERO
	mock_player.global_position = Vector3.ZERO

func after_each():
	condition = null
	mock_owner = null
	mock_player = null
	behaviour_tree = null

## Test basic functionality
func test_returns_failure_when_no_player():
	behaviour_tree.set_blackboard_value("player", null)

	var result = condition.tick(behaviour_tree.blackboard)
	
	assert_eq(result, BehaviourTreeResult.Status.FAILURE)

func test_returns_failure_when_no_owner():
	behaviour_tree.set_blackboard_value("owner", null)
	
	var result = condition.tick(behaviour_tree.blackboard)
	
	assert_eq(result, BehaviourTreeResult.Status.FAILURE)

func test_returns_failure_when_both_null():
	behaviour_tree.set_blackboard_value("player", null)
	behaviour_tree.set_blackboard_value("owner", null)

	var result = condition.tick(behaviour_tree.blackboard)
	
	assert_eq(result, BehaviourTreeResult.Status.FAILURE)

## Test range detection
func test_returns_success_when_player_at_exact_range():
	# Position player at exact range distance
	mock_player.global_position = Vector3(5.0, 0, 0)  # Exactly 5.0 units away
	
	var result = condition.tick(behaviour_tree.blackboard)
	
	assert_eq(result, BehaviourTreeResult.Status.SUCCESS)

func test_returns_success_when_player_within_range():
	# Position player within range
	mock_player.global_position = Vector3(3.0, 0, 0)  # 3.0 units away (< 5.0)
	
	var result = condition.tick(behaviour_tree.blackboard)
	
	assert_eq(result, BehaviourTreeResult.Status.SUCCESS)

func test_returns_failure_when_player_outside_range():
	# Position player outside range
	mock_player.global_position = Vector3(6.0, 0, 0)  # 6.0 units away (> 5.0)
	
	var result = condition.tick(behaviour_tree.blackboard)
	
	assert_eq(result, BehaviourTreeResult.Status.FAILURE)

func test_returns_success_when_player_at_origin_with_owner():
	# Both at origin (distance = 0, within any positive range)
	mock_owner.global_position = Vector3.ZERO
	mock_player.global_position = Vector3.ZERO
	
	var result = condition.tick(behaviour_tree.blackboard)
	
	assert_eq(result, BehaviourTreeResult.Status.SUCCESS)

## Test 3D distance calculations
func test_works_with_y_axis_distance():
	# Player above owner
	mock_player.global_position = Vector3(0, 4.0, 0)  # 4.0 units up
	
	var result = condition.tick(behaviour_tree.blackboard)
	
	assert_eq(result, BehaviourTreeResult.Status.SUCCESS)

func test_works_with_z_axis_distance():
	# Player in front/behind owner
	mock_player.global_position = Vector3(0, 0, 3.0)  # 3.0 units forward
	
	var result = condition.tick(behaviour_tree.blackboard)
	
	assert_eq(result, BehaviourTreeResult.Status.SUCCESS)

func test_works_with_diagonal_distance():
	# Player at diagonal (3,4,0 = 5 units total distance)
	mock_player.global_position = Vector3(3.0, 4.0, 0)
	
	var result = condition.tick(behaviour_tree.blackboard)
	
	assert_eq(result, BehaviourTreeResult.Status.SUCCESS)

func test_diagonal_distance_just_outside_range():
	# Player at diagonal just outside range
	mock_player.global_position = Vector3(3.0, 4.1, 0)
	
	var result = condition.tick(behaviour_tree.blackboard)
	
	assert_eq(result, BehaviourTreeResult.Status.FAILURE)

## Test different range values
func test_works_with_small_range():
	condition.range = 1.0
	mock_player.global_position = Vector3(0.5, 0, 0)  # Within small range
	
	var result = condition.tick(behaviour_tree.blackboard)
	
	assert_eq(result, BehaviourTreeResult.Status.SUCCESS)

func test_fails_with_small_range():
	condition.range = 1.0
	mock_player.global_position = Vector3(1.5, 0, 0)  # Outside small range
	
	var result = condition.tick(behaviour_tree.blackboard)
	
	assert_eq(result, BehaviourTreeResult.Status.FAILURE)

func test_works_with_large_range():
	condition.range = 100.0
	mock_player.global_position = Vector3(50, 50, 0)  # ~70.7 units (within 100)
	
	var result = condition.tick(behaviour_tree.blackboard)
	
	assert_eq(result, BehaviourTreeResult.Status.SUCCESS)

func test_zero_range_only_works_at_origin():
	condition.range = 0.0
	
	# At origin - should succeed
	mock_player.global_position = Vector3.ZERO
	var result1 = condition.tick(behaviour_tree.blackboard)
	assert_eq(result1, BehaviourTreeResult.Status.SUCCESS)
	
	# Any distance - should fail
	mock_player.global_position = Vector3(0.1, 0, 0)
	var result2 = condition.tick(behaviour_tree.blackboard)
	assert_eq(result2, BehaviourTreeResult.Status.FAILURE)

## Test owner position changes
func test_owner_and_player_both_move_within_range():
	# Move both but keep them close
	mock_owner.global_position = Vector3(10, 0, 0)
	mock_player.global_position = Vector3(12, 0, 0)  # 2 units apart
	
	var result = condition.tick(behaviour_tree.blackboard)
	
	assert_eq(result, BehaviourTreeResult.Status.SUCCESS)

func test_owner_and_player_both_move_outside_range():
	# Move both but keep them far apart
	mock_owner.global_position = Vector3(10, 0, 0)
	mock_player.global_position = Vector3(20, 0, 0)  # 10 units apart (> 5.0 range)
	
	var result = condition.tick(behaviour_tree.blackboard)
	
	assert_eq(result, BehaviourTreeResult.Status.FAILURE)

## Test edge cases
func test_handles_negative_positions():
	mock_owner.global_position = Vector3(-10, -5, -3)
	mock_player.global_position = Vector3(-8, -3, -1)  # Close to owner
	
	var result = condition.tick(behaviour_tree.blackboard)
	
	# Distance should be calculated correctly regardless of negative coordinates
	assert_eq(result, BehaviourTreeResult.Status.SUCCESS)

func test_very_large_distances():
	condition.range = 10.0
	mock_owner.global_position = Vector3.ZERO
	mock_player.global_position = Vector3(1000, 1000, 1000)  # Very far
	
	var result = condition.tick(behaviour_tree.blackboard)
	
	assert_eq(result, BehaviourTreeResult.Status.FAILURE)
