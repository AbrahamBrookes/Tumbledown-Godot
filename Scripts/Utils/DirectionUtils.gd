extends Node



# Snap the direction to the nearest cardinal direction
func get_cardinal_direction(direction: Vector2) -> Vector2:
	# Check the angle to determine the cardinal direction
	if direction.x > 0.5:
		return Vector2.LEFT
	elif direction.x < -0.5:
		return Vector2.RIGHT
	elif direction.y > 0.5:
		return Vector2.UP
	elif direction.y < -0.5:
		return Vector2.DOWN
	else:
		return Vector2.ZERO

# Get the rotation in degrees based on the cardinal direction
func get_cardinal_rotation(direction: Vector2) -> float:
	match direction:
		Vector2.RIGHT:
			return 0.0
		Vector2.LEFT:
			return 180.0
		Vector2.UP:
			return -90.0
		Vector2.DOWN:
			return 90.0
		_:
			return 0.0
