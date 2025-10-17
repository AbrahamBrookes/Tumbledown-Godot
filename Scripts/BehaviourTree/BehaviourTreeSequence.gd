extends Node

class_name BehaviourTreeSequence

## A BehaviourTreeSequence is a type of composite node in a behavior tree.
## It executes its child nodes in order, from top to bottom. Generally we
## will have conditions first, then actions. If any condition fails the
## sequence fails and stops executing further children. If all conditions
## are met, the actions are executed in order, resulting in an action.

func tick(blackboard: Dictionary) -> int:
    for child in get_children():
        if child.has_method("tick"):
            var result = child.tick(blackboard)
            
            match result:
                BehaviourTreeResult.Status.FAILURE:
                    return BehaviourTreeResult.Status.FAILURE
                BehaviourTreeResult.Status.RUNNING:
                    return BehaviourTreeResult.Status.RUNNING
                # SUCCESS: continue to next child
        else:
            push_error("BehaviourTreeSequence: Child '%s' does not have tick() method!" % child.name)
            return BehaviourTreeResult.Status.FAILURE
    
    # All children succeeded
    return BehaviourTreeResult.Status.SUCCESS