extends State
class_name Leech_Pursue

var target
@export var movement_speed: float = 5.0
var movement_delta: float
var can_leech_move: bool # when the timer times down, we can move
var leech_jump_location: Vector3 # where the leech will next jump to
@export var leech_jump_length: float = 2.0
@export var mesh: Node3D

func Enter(extra_data = null):
	target = extra_data["target"]
	$LeechJumpTimer.start()
	$LeechPauseTimer.start()
	
	# blend our walking animation
	stateMachine.travel("Locomote")
	animTree.set("parameters/StateMachine/Locomote/blend_position", 1)

func Exit():
	$LeechJumpTimer.stop()
	$LeechPauseTimer.stop()
	pass

func Update(_delta: float):
	pass

func Physics_Update(delta: float):
	# the leech has a jump stop style of movement, so we want to move the actual object
	# at odd times. We have a timer that is the length of time from the start of the animation
	# to the moment the leech should start moving. When that timer times down, we run our actual
	# location transformation in a bit of a snap.
	
	# lerp to look at the target
	mesh.look_at(Vector3(target.global_position.x, owner.global_position.y + 0.25, target.global_position.z), Vector3.UP)

func _on_leech_jump_timer_timeout():
	leech_jump_location = target.global_position - owner.global_position
	# limit the distance to a jump unit
	leech_jump_location = owner.global_position + leech_jump_location.normalized() * leech_jump_length
	owner.apply_central_impulse(leech_jump_location * movement_speed)

func _on_leech_pause_timer_timeout():
	Transitioned.emit("Leech_Pursue", {
		target = target
	})
