extends Node
class_name State

signal Transitioned

# playercharacter is the immediate scene root
@onready var playerCharacter : PlayerCharacter = owner
@onready var animTree = owner.get_node("SkinnedMesh/AnimationTree")
@onready var stateMachine = animTree.get("parameters/StateMachine/playback")

func Enter(extra_data = null):
	pass


func Exit():
	pass


func Update(_delta: float):
	pass


func Physics_Update(_delta: float):
	pass 
