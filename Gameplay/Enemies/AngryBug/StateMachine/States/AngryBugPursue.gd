extends State
class_name AngryBugPursue

@export var agent: NavigationAgent3D
@export var mesh: Node3D

var target: Node3D

func Enter(extra_data = null):
	target = extra_data
	agent.max_speed = owner.TRAVEL_SPEED

func Exit():
	target = null

func Physics_Update(delta):
	if not target:
		Transitioned.emit("AngryBugIdle")
		return
		
	# update the target
	agent.target_position = target.global_transform.origin

	# get next nav point
	var next_point = agent.get_next_path_position()
	var dir = (next_point - global_transform.origin).normalized()
	# apply gravity + movement
	owner.velocity = Vector3(dir.x, 0, dir.z) * owner.TRAVEL_SPEED
	owner.velocity.y -= ProjectSettings.get_setting("physics/3d/default_gravity") * delta

	# smooth look
	var look_dir = (
		Vector3(next_point.x, global_transform.origin.y, next_point.z) - global_transform.origin
	).normalized()
	var desired_basis = Basis.looking_at(look_dir, Vector3.UP)
	var current_basis = mesh.global_transform.basis
	var slerped = current_basis.slerp(desired_basis, owner.TURN_SPEED * delta)
	mesh.global_transform.basis = slerped
	
	owner.move_and_slide()


func _on_agrozone_body_entered(body):
	if "team" in body && body.team == 1:
		Transitioned.emit("AngryBugPursue", body)


func _on_agrozone_body_exited(body):
	if body == target:
		target = null
		Transitioned.emit("AngryBugIdle", body)

func _on_attackzone_body_entered(body):
	if "team" in body && body.team == 1:
		# attack them
		Transitioned.emit("AngryBugAttack", body)
		
func _on_attackzone_body_exited(body):
	if "team" in body && body.team == 1:
		# chase them
		Transitioned.emit("AngryBugPursue", body)
