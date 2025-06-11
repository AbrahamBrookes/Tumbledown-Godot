extends State
class_name AngryBugAttackCooldown

var target: Node3D
@export var timer: Timer


func Enter(extra_data = null):
	target = extra_data
	# fire the timer
	timer.start(owner.ATTACK_COOLDOWN)


func Exit():
	pass


func Update(_delta: float):
	pass


func Physics_Update(_delta: float):
	pass

func _on_timer_timeout():
	# when the timer times out, we can go back to attacking
	machine.travel("AngryBugAttack", target)
