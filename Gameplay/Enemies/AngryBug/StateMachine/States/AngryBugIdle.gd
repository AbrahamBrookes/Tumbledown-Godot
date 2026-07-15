extends State
class_name AngryBugIdle

## a ref to the brain
@export var brain: EnemyBrain

func Physics_Update(_delta: float):
	# if we have an enemy in the possible threats, pursue it
	if brain.PossibleThreats.size():
		Transitioned.emit("AngryBugPursue", brain.PossibleThreats.front())
