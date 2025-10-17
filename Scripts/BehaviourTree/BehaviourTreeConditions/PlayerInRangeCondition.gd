extends BehaviourTreeCondition

class_name PlayerInRangeCondition

@export var range: float = 100.0

# cache the owner as it won't change
var thinker: Node3D

func tick(blackboard: Dictionary) -> BehaviourTreeResult.Status:
	var player: Node3D = blackboard.get("player")
	var thinker: Node3D = blackboard.get("owner")

	if not player or not thinker:
		return BehaviourTreeResult.Status.FAILURE

	var distance = thinker.global_position.distance_squared_to(player.global_position)
	if distance <= range * range:
		return BehaviourTreeResult.Status.SUCCESS
	return BehaviourTreeResult.Status.FAILURE
