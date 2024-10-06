extends State
class_name Leech_Idle

func Enter(extra_data = null):
	stateMachine.travel("Idle")

func Exit():
	pass


func Update(_delta: float):
	pass


func Physics_Update(_delta: float):
	pass 
