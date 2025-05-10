extends State
class_name AngryBugIdle

func Enter(extra_data = null):
	machine.animTree.set("parameters/AnimSpeed/scale", 2.0)
	get_tree()


func Exit():
	pass


func Update(_delta: float):
	pass


func Physics_Update(_delta: float):
	pass 
