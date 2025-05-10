extends Node3D
class_name State

signal Transitioned

# playercharacter is the immediate scene root
@onready var playerCharacter = owner

# the state machine is always the immediate parent of the state it is managing
@onready var machine = get_parent()

func Enter(extra_data = null):
	pass


func Exit():
	pass


func Update(_delta: float):
	pass


func Physics_Update(_delta: float):
	pass 
