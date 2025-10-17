extends BehaviourTreeCondition

class_name StateMachineStatesCondition

# This condition checks if the state machine is in one of the specified states
# and if so returns success, otherwise failure.

@export var states: Array[String] = []

func tick(blackboard: BehaviourTreeBlackboard) -> int:
	var stateMachine: StateMachine = blackboard.get_blackboard_value("state_machine", null)
	if stateMachine and stateMachine.is_in_states(states):
		return BehaviourTreeResult.Status.SUCCESS
	return BehaviourTreeResult.Status.FAILURE
