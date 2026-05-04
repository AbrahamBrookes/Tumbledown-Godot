extends State
class_name Jumping

# Jump parameters
@export var jump_power = 10.0 # Higher upward force for a quick jump
@export var lateral_damp = 0.1 # Minimal lateral movement
@export var max_fall_speed = 25.0 # Faster descent for a toy-like jump

# Gravity curve for tuning jump arc
@export var gravity_curve: Curve = Curve.new() # Allows fine-tuning of gravity over time

# Gravity from project settings
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# State variables
var can_boost = true
var launch_direction: Vector3 = Vector3.ZERO
var has_left_ground = false

@onready var timer: Timer = $Timer

func Enter(_extra_data = null):
	# Set the initial launch direction based on current velocity
	launch_direction = Vector3(
		playerCharacter.velocity.x * 0.2, # Very minimal lateral influence
		jump_power, # Strong upward force
		playerCharacter.velocity.z * 0.2
	)
	
	can_boost = true
	timer.start() # Start the timer for the boost phase

func Exit():
	# Reset any jump-specific variables if needed
	can_boost = false
	has_left_ground = false

func Update(_delta: float):
	# No specific logic for Update in this state
	pass

func Physics_Update(delta: float):
	# Apply gravity using the curve for fine-tuned control
	var curve_gravity = gravity * gravity_curve.sample_baked(timer.time_left / timer.wait_time)
	launch_direction.y = max(
		launch_direction.y - curve_gravity * delta,
		-max_fall_speed
	)

	# Handle minimal lateral movement based on player input
	var input_direction = Vector3(
		Input.get_action_strength("walk_east") - Input.get_action_strength("walk_west"),
		0,
		Input.get_action_strength("walk_south") - Input.get_action_strength("walk_north")
	)

	# Calculate desired velocity with reduced lateral influence
	desired_velocity = Vector3(
		launch_direction.x + input_direction.x * lateral_damp,
		launch_direction.y,
		launch_direction.z + input_direction.z * lateral_damp
	)

	# Apply the calculated velocity to the player character
	playerCharacter.velocity = desired_velocity
	playerCharacter.move_and_slide()

	# Check if the player has landed
	if not can_boost and playerCharacter.is_on_floor():
		Transitioned.emit("Locomote")
		return

func _on_timer_timeout():
	# Disable boost after the timer ends
	can_boost = false
