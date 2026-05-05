extends State

class_name Drowning

## the last known safe position to warp to
var last_known_safe_position

func Enter(extra_data = null):
	if extra_data is not Vector3:
		push_error("last know position must be passed to Drowning state")
		Transitioned.emit("Locomote")
		return
	
	last_known_safe_position = extra_data
	$MoveAfterFallingInTimer.start()

func Exit():
	pass

func Update(_delta: float):
	pass

func Physics_Update(_delta: float):
	if $MoveAfterFallingInTimer.is_stopped():
		owner.global_position = owner.last_known_safe_position
		Transitioned.emit("Locomote")
