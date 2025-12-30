extends State
class_name Jumping

# how much boost we apply initially
@export var jump_power = 8
# multiple lateral boost by this much
@export var lateral_damp = 0.8
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var can_boost = true
var launch_direction: Vector3 = Vector3.ZERO

@onready var timer : Timer = $Timer

var has_left_ground = false

func Enter(_extra_data = null):
	launch_direction = Vector3(
		playerCharacter.velocity.x,
		jump_power * 1.1,
		playerCharacter.velocity.z
	)
	
	can_boost = true
	timer.start()

func Exit():
	pass

func Update(_delta: float):
	pass

func Physics_Update(delta: float):
	# Decay launch_direction.y manually for jump arc
	var fall_multiplier := 4  # tweak for floatiness
	var max_fall_speed := 20.0
	launch_direction.y = max(launch_direction.y - gravity * fall_multiplier * delta, -max_fall_speed)

	# allow the player to control a little bit
	var input_direction = Vector3(
		Input.get_action_strength("walk_east") - Input.get_action_strength("walk_west"),
		0,
		Input.get_action_strength("walk_south") - Input.get_action_strength("walk_north")
	)

	desired_velocity = Vector3(
		launch_direction.x + input_direction.x * lateral_damp,
		launch_direction.y,
		launch_direction.z + input_direction.y * lateral_damp
	)

	# Check if we have hit the ground so we can land
	if not can_boost:
		if playerCharacter.is_on_floor():
			Transitioned.emit("Locomote")
			return

func _on_timer_timeout():
	can_boost = false
