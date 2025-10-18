extends Node

class_name BehaviourTreeBlackboard

## The BehaviourTreeBlackboard is a data store for behaviour trees with regards
## to an NPC or any decision making structure. It's just a dictionary with some
## accessors and it acts as the single datastore for an NPC's decision making

@export var data: Dictionary = {}

# a reference to the state machine we are interacting with
@export var state_machine: StateMachine

# if we have no state machine assigned, warn on ready
func _ready():
	if not state_machine:
		push_warning("BehaviourTreeBlackboard: No state machine assigned! State changing actions will fail.")

## Helper methods
func set_blackboard_value(key: String, value: Variant):
	data[key] = value

func get_blackboard_value(key: String, default = null):
	return data.get(key, default)
