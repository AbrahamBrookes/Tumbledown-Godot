extends State

class_name PushingPushable

## This state is used to push objects that can be pushed. On enter we will
## call "be_pushed" on the extra data (the pushable object) to let it know
## we are pushing it. The pushable travels by itself (it is a character body
## with its own state machine and movement logic). The player can always bail
## on the push as well by releasing movement input or walking away.

# the thing we are pushing
var pushable_object: Pushable = null

# our raycast for detecting collision with the pushable
@export var push_ray: RayCast3D

func Enter(pushable = null):
	# if the pushable can't be pushed, bail out
	if not pushable or not pushable.has_method("be_pushed"):
		push_warning("PushingPushable: No valid pushable object passed in!")
		Transitioned.emit("Locomote")
		return

	pushable_object = pushable

	# tell the pushable we are pushing it
	pushable_object.be_pushed(playerCharacter)

# in physics process, check if we should stop pushing
func Physics_Update(_delta: float) -> void:
	# if we have no pushable, bail out
	if not pushable_object:
		Transitioned.emit("Locomote")
		return
	
	var input_direction = InputUtils.get_stick_input()

	# if there is no input, bail out
	if input_direction.length() < 0.5:
		print("input")
		pushable_object.stop_being_pushed()
		Transitioned.emit("LeaningPushable", pushable_object)
		return

	# if we have turned away from the pushable, bail out
	var to_pushable = (pushable_object.global_position - playerCharacter.global_position)
	if input_direction.dot(to_pushable) < 0.75:
		print("dot")
		pushable_object.stop_being_pushed()
		Transitioned.emit("Locomote")
		return
	
	# if the raycast is no longer intersecting the pushable, bail out
	if not push_ray.is_colliding():
		print("no collide")
		pushable_object.stop_being_pushed()
		Transitioned.emit("Locomote")
		return
	# or if we are colliding but not with the pushable
	else:
		var collider = push_ray.get_collider()
		if not collider == pushable_object:
			print("not object")
			pushable_object.stop_being_pushed()
			Transitioned.emit("Locomote")
			return
		
	# all good! we can move now
	var move_direction = input_direction * pushable_object.push_speed
	desired_velocity.x = move_direction.x
	desired_velocity.z = move_direction.z
	
	# rotate the player to face the cardinal direction
	var cardinal_input = InputUtils.get_cardinal_input()
	playerCharacter.mesh.look_at(
		Vector3(
			playerCharacter.mesh.global_transform.origin.x + cardinal_input.x,
			playerCharacter.mesh.global_transform.origin.y,
			playerCharacter.mesh.global_transform.origin.z + cardinal_input.y
		),
		Vector3.UP
	)
