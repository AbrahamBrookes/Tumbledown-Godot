extends State
class_name AngryBugAttack

var target: Node3D
@export var mesh: Node3D

func Enter(extra_data = null):
	target = extra_data

func Exit():
	pass


func Update(_delta: float):
	pass


func Physics_Update(delta: float):
	var look_dir = (target.global_transform.origin - global_transform.origin).normalized()
	var desired_basis = Basis.looking_at(look_dir, Vector3.UP)
	var current_basis = mesh.global_transform.basis
	var slerped = current_basis.slerp(desired_basis, owner.TURN_SPEED * delta)
	mesh.global_transform.basis = slerped

func _on_attack_animation_finished():
	print('attack animation finished')
	Transitioned.emit("AngryBugAttackCooldown", target)

func _on_attack_animation_apply_damage():
	if !target:
		pass
	
	# Check if the body has a receive damage function
	if target.has_method("receive_damage"):

		#check the target is within attack range
		if global_transform.origin.distance_to(target.global_transform.origin) > owner.ATTACK_RANGE:
			# Target is out of range, do not apply damage
			machine.travel("AngryBugPursue", target)
			return

		# our damage is a special type with a type and amount
		var damage = Damage.new()
		damage.type = Damage.DamageType.SPIKY
		damage.amount = 1
		damage.source = self
		# Call the receive damage function on the body
		target.receive_damage(damage)


func _on_timer_timeout():
	pass # Replace with function body.
