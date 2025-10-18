class_name BlackboardReaderAction
extends BehaviourTreeAction

var read_value: String
var health_value: int

func tick(blackboard: BehaviourTreeBlackboard) -> int:
	read_value = blackboard.get_blackboard_value("test_key", "")
	health_value = blackboard.get_blackboard_value("health", 0)
	return BehaviourTreeResult.Status.SUCCESS