extends State
class_name Leech_Hurt

# This state is responsible for sailing through the air after being hurt

func Enter(extra_data = null):
	# extra_data = {
	# 	amount:int,
	# 	origin:Vector3,
	# 	impulseMultiplier:int = 50
	# }

	var origin = extra_data["origin"]
	var impulseMultiplier = extra_data["impulseMultiplier"]

	# get the vector from the source to us
	var attackVector = owner.global_transform.origin - origin
	# normalize it
	var normalizedAttackVector = attackVector.normalized()
	normalizedAttackVector.y = 0.5
	# apply impulse
	var velocity = normalizedAttackVector * impulseMultiplier * 40
	owner.apply_central_impulse(velocity)
	
	# blend animations and such
	
	# start our timer to see when we can go back to the previous state
	$ResumeTimer.start()

func Exit():
	pass

func Update(_delta: float):
	pass

func Physics_Update(delta: float):
	pass


func _on_resume_timer_timeout():
	Transitioned.emit('leech_idle')
