extends Node

class_name BehaviourTreeAction

## A BehaviourTreeAction is an action that an AI agent can perform.
## It may have children as decorators to modify its behavior.
## The parent node is typically a sequence or selector that determines
## when this action is executed.

func tick(_blackboard: Dictionary) -> int:
    # Override this method in subclasses to implement specific action logic.
    # Return SUCCESS if the action completed successfully,
    # FAILURE if the action failed,
    # or RUNNING if the action needs more time to complete.
    push_error("BehaviourTreeAction: tick() not implemented!")
    return BehaviourTreeResult.Status.FAILURE