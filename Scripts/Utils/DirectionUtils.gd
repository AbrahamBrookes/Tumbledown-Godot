extends Node

# Snap the direction to the nearest cardinal direction
func get_cardinal_direction(direction: Vector2) -> Vector2:
	# Check the angle to determine the cardinal direction
	if direction.length() < 0.2:
		return Vector2.ZERO
		
	var abs_x = abs(direction.x)
	var abs_y = abs(direction.y)

	if abs_x > abs_y:
		# Horizontal movement wins
		return Vector2.RIGHT if direction.x < 0 else Vector2.LEFT
	elif abs_y > abs_x:
		# Vertical movement wins
		return Vector2.DOWN if direction.y < 0 else Vector2.UP
	else:
		# They are perfectly equal (e.g., exactly 45 degrees)
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
