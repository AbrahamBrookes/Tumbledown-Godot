extends State
class_name AngryBugWasAttacked

var pushback: Vector3
const DRAG := 10.0
var GRAVITY = ProjectSettings.get_setting("physics/3d/default_gravity")
var target

func Enter(extra_data = null):
	owner.velocity = extra_data.pushback
	target = extra_data.target

func Exit():
	pass


func Update(_delta: float):
	pass


func Physics_Update(delta: float):
	# apply gravity
	owner.velocity.y -= GRAVITY * delta

	# apply drag
	owner.velocity.x = lerp(owner.velocity.x, 0.0, DRAG * delta)
	owner.velocity.z = lerp(owner.velocity.z, 0.0, DRAG * delta)
	
	owner.move_and_slide()
	
	# once the velocity reaches zero, return to idle
	if owner.velocity.length() < 0.1:
		Transitioned.emit("AngryBugPursue", target)
		return
	
