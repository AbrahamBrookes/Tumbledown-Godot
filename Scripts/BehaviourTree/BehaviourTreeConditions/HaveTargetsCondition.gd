extends BehaviourTreeCondition

class_name HasTargetsCondition

## Simply a logical branch based on if our blackboard has anything it its
## "targets" array value

func tick(blackboard: BehaviourTreeBlackboard) -> int:
	var targets = blackboard.get_blackboard_value("targets", [])

	if targets.size() > 0:
		return BehaviourTreeResult.Status.SUCCESS
	return BehaviourTreeResult.Status.FAILURE
	
	
	
