extends State
class_name Leech_Idle

func Enter(extra_data = null):
	stateMachine.travel("Idle")

func Exit():
	pass


func Update(_delta: float):
	pass


func Physics_Update(_delta: float):
	# if the owners pursueable_enemies array has an entry, pursue it
	if owner.pursueable_enemies.size() > 0:
		Transitioned.emit("leech_pursue", {"target": owner.pursueable_enemies[0]})
		return
