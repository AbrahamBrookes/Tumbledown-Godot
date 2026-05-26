extends State

class_name RollyLogBeingPushed

## This state is for a rolling log that rolls a given distance then stops.
## The way we handle the actual movement is by accepting player input and
## moving the pushable while in this state. The rolly log keeps rolling until
## it hits something or falls off a ledge.

## How fast do we roll?
@export var speed := 2.5

## Grace window after leaving floor before exiting this state
@export var coyote_time := 0.12

## the mesh to spin as animation
@export var mesh: Node3D
@export var log_radius := 0.5 # tune to your mesh size


# Get the gravity from the project settings once
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

## the initial push direction as a v3 enum
var initial_direction: Vector3
var coyote_timer := 0.0

## When we enter this state we cache the direction so we can keep rolling
func Enter(extra_data: Variant = null):
	initial_direction = Vector3(
		extra_data.x * -1,
		0,
		extra_data.y * -1
	)
	coyote_timer = 0.0

## During physics update, handle player input
func Physics_Update(_delta: float):
	# if the initial direction is not sufficiently aligned with local forward or back, bail out
	var alignment = abs(initial_direction.dot(owner.transform.basis.z))
	if alignment < 0.75:
		push_warning("RollyLogBeingPushed state expects the initial push direction to be strongly aligned with the local forward or back of the log. Alignment: %s".format(alignment))
		initial_direction = Vector3.ZERO

		Transitioned.emit("Idle")
		return
	
	owner.velocity.x = initial_direction.x * speed
	owner.velocity.z = initial_direction.z * speed
	owner.velocity.y -= gravity
	
	# Move and detect collisions
	owner.move_and_slide()

	# Check if the log has stopped moving or is no longer colliding
	if owner.velocity.length() < 0.01:
		Transitioned.emit("Idle")
		return
		
	# If we leave the floor, allow a short coyote-time grace period before transition.
	if owner.is_on_floor():
		coyote_timer = 0.0
	else:
		coyote_timer += _delta
		if coyote_timer >= coyote_time:
			Transitioned.emit("Idle")
			return

	# Rotate the mesh so that it rotates towards the direction it's moving. We can use the velocity to determine how much to rotate, and we can use the initial push direction to determine which way is "forward" for the log.

	if mesh:
		var planar_velocity = Vector3(owner.velocity.x, 0.0, owner.velocity.z)
		if planar_velocity.length_squared() > 0.0001:
			var move_dir = planar_velocity.normalized()
			var forward = owner.transform.basis.z.normalized()

			# +1 when moving "forward" along local z, -1 when moving backward
			var direction_sign = sign(move_dir.dot(forward))
			if direction_sign == 0.0:
				direction_sign = 1.0

			var distance = planar_velocity.length() * _delta
			var rotation_amount = direction_sign * (distance / log_radius)
			mesh.rotate_x(rotation_amount)
