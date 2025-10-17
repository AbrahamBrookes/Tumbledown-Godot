extends Node
class_name BehaviourTree

## Main behavior tree that manages execution and blackboard
## Add this to your enemy and build your tree structure as children

var blackboard: Dictionary = {}
var root_node: Node

func _ready():
	# Get the first child as root node
	if get_child_count() > 0:
		root_node = get_child(0)
	else:
		push_error("BehaviourTree: No root node found!")

func _process(_delta):
	# Execute the tree every frame
	if root_node and root_node.has_method("tick"):
		var result = root_node.tick(blackboard)
		handle_result(result)

func handle_result(result: int):
	match result:
		BehaviourTreeResult.Status.SUCCESS:
			# Tree completed successfully - maybe restart next frame
			pass
		BehaviourTreeResult.Status.FAILURE:
			# Tree failed - handle error or fallback behavior
			pass
		BehaviourTreeResult.Status.RUNNING:
			# Tree still processing - continue next frame
			pass

## Helper methods
func set_blackboard_value(key: String, value: Variant):
	blackboard[key] = value

func get_blackboard_value(key: String, default = null):
	return blackboard.get(key, default)

## Manual tick (for testing or custom control)
func tick() -> int:
	if root_node and root_node.has_method("tick"):
		return root_node.tick(blackboard)
	return BehaviourTreeResult.Status.FAILURE
