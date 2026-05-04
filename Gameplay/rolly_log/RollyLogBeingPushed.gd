extends State

class_name RollyLogBeingPushed

## This state is for a rolling log that rolls a given distance then stops.
## The way we handle the actual movement is by accepting player input and
## moving the pushable while in this state. The rolly log keeps rolling until
## it hits something or falls off a ledge.

## How fast do we roll?
@export var speed := 2.5

## the mesh to spin as animation
@export var mesh: Node3D

# Get the gravity from the project settings once
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

## the initial push direction as a v3 enum
var initial_direction: Vector3

## When we enter this state we cache the direction so we can keep rolling
func Enter(extra_data: Variant = null):
	initial_direction = Vector3(
		extra_data.x * -1,
		0,
		extra_data.y * -1
	)

## During physics update, handle player input
func Physics_Update(_delta: float):
	# if the initial direction is not sufficiently aligned with local forward or back, bail out
	var alignment = abs(initial_direction.dot(owner.transform.basis.z))
	if alignment < 0.75:
		push_warning("RollyLogBeingPushed state expects the initial push direction to be strongly aligned with the local forward or back of the log. Alignment: %s".format(alignment))
		initial_direction = Vector3.ZERO

		Transitioned.emit("BasicPushableIdle")
		return
	
	owner.velocity.x = initial_direction.x * speed
	owner.velocity.z = initial_direction.z * speed
	owner.velocity.y -= gravity
	
	# Move and detect collisions
	owner.move_and_slide()

	# Check if the log has stopped moving or is no longer colliding
	if owner.velocity.length() < 0.01:
		Transitioned.emit("BasicPushableIdle")
		return
		
	# If we are falling, transition to idle so we stop moving
	if not owner.is_on_floor():
		Transitioned.emit("BasicPushableIdle")
		return

	# Rotate the mesh based on the movement
	if mesh:
		var rotation_amount = speed * _delta * 1.25
		mesh.rotate_x(rotation_amount)
