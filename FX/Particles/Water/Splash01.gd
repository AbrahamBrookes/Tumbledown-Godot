extends Node3D

class_name Splash01

# we'll cast a ray to find the collision
@export var ray: RayCast3D
@export var height_offset: float = 0.0

func splash(position: Vector3):
	# Start from the requested world position so the ray samples at the caller location.
	global_position = position if position else owner.global_position
	ray.force_raycast_update()

	if ray.is_colliding():
		var collision = ray.get_collision_point()
		global_position = Vector3(collision.x, collision.y + height_offset, collision.z)
	else:
		global_position.y += height_offset

	$AnimationPlayer.stop()
	$AnimationPlayer.play("splash")
	
