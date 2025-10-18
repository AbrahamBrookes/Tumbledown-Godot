class_name MockCondition
extends BehaviourTreeCondition

var return_value: int = BehaviourTreeResult.Status.SUCCESS
var was_ticked: bool = false

func tick(_blackboard: BehaviourTreeBlackboard) -> int:
	was_ticked = true
	return return_value