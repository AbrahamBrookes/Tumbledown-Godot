extends Node

class_name BehaviourTreeSelector

## A BehaviourTreeSelector node will execute its children in order until one of them returns SUCCESS.
## If a child returns SUCCESS, the selector returns SUCCESS.
## If all children return FAILURE, the selector returns FAILURE.
## If a child returns RUNNING, the selector returns RUNNING and will resume from that child
## on the next tick.

func tick(blackboard: Dictionary) -> int:
    for child in get_children():
        if child.has_method("tick"):
            var result = child.tick(blackboard)
            
            match result:
                BehaviourTreeResult.Status.SUCCESS:
                    return BehaviourTreeResult.Status.SUCCESS
                BehaviourTreeResult.Status.RUNNING:
                    return BehaviourTreeResult.Status.RUNNING
                # FAILURE: continue to next child
        else:
            push_error("BehaviourTreeSelector: Child '%s' does not have tick() method!" % child.name)
            return BehaviourTreeResult.Status.FAILURE
    
    # All children failed
    return BehaviourTreeResult.Status.FAILURE