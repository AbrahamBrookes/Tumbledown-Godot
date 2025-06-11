extends State
class_name AngryBugLocomote

func Enter(extra_data = null):
	# set anim speed
	machine.animTree.set("parameters/StateMachine/AngryBugLocomote/blend_position", 2)

func Exit():
	pass


func Update(_delta: float):
	pass


func Physics_Update(_delta: float):
	pass
