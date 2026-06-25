extends State
class_name FoxkinIdleBounce

@export var jump_velocity: float = 4.5
@export var side_speed: float = 2.0
@export var max_travel_distance: float = 1.5

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

# We track travel using a simple float counter instead of checking world position
var current_travel: float = 0.0
var moving_right: bool = true

func _ready() -> void:
	# Give it an initial bounce kick
	if playerCharacter:
		playerCharacter.velocity.y = jump_velocity

func _physics_process(delta: float) -> void:
	if not playerCharacter:
		return

	# 1. Handle Vertical Bouncing (Y Axis)
	if not playerCharacter.is_on_floor():
		playerCharacter.velocity.y -= gravity * delta
	else:
		playerCharacter.velocity.y = jump_velocity

	# 2. Track strictly how far we've traveled side-to-side
	# (Speed * delta gives us the exact distance covered this frame)
	var frame_distance = side_speed * delta
	
	if moving_right:
		current_travel += frame_distance
		if current_travel >= max_travel_distance:
			moving_right = false
	else:
		current_travel -= frame_distance
		if current_travel <= -max_travel_distance:
			moving_right = true

	# 3. Apply the movement LOCAL to the character
	# This ensures "Side-to-Side" is always perfectly Left and Right based on where the character faces
	var side_direction = playerCharacter.global_transform.basis.x
	var movement_vector = side_direction * (side_speed if moving_right else -side_speed)
	
	playerCharacter.velocity.x = movement_vector.x
	playerCharacter.velocity.z = movement_vector.z

	# 4. Call move_and_slide on the actual character body`
	# Note: State machines usually call this on the playerCharacter node itself, not the state node
	playerCharacter.move_and_slide()
