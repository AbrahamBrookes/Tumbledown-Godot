extends State
class_name Leech_Locomote

func Enter(extra_data = null):
	print("Leecjsdfsdf")
	stateMachine.travel("Idle")
	animTree.set("parameters/StateMachine/Locomote/blend_position", 0.0)

func Exit():
	pass


func Update(_delta: float):
	pass


func Physics_Update(_delta: float):
	pass 
