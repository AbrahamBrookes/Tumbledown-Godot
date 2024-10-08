extends State
class_name Leech_Locomote

# an int for the number of frames we skip before doing stuff
var frame_skip = 240

func Enter(extra_data = null):
	print("Leecjsdfsdf")
	stateMachine.travel("Idle")
	animTree.set("parameters/StateMachine/Locomote/blend_position", 0.0)

func Exit():
	pass


func Update(_delta: float):
	pass


func Physics_Update(_delta: float):
	
