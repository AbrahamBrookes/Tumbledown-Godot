extends State
class_name Jumping

# how much boost we apply initially
@export var jump_power = 10000.0
# multiple lateral boost by this much
@export var lateral_damp = 0.8

var can_boost = true
var launch_direction : Vector3 = Vector3.ZERO

@onready var timer : Timer = $Timer

var has_left_ground = false

func Enter(extra_data = null):
	can_boost = true

	var input_dir = Input.get_vector("walk_west", "walk_east", "walk_north", "walk_south")
	launch_direction = Vector3(
		(Input.get_action_strength("walk_east") - Input.get_action_strength("walk_west")) * jump_power * lateral_damp,
		jump_power,
		(Input.get_action_strength("walk_south") - Input.get_action_strength("walk_north")) * jump_power * lateral_damp
	)
	
	timer.start()

func Exit():
	pass


func Update(_delta: float):
	pass


func Physics_Update(_delta: float):
	# if the player lets go of jump, stop jumping
	if Input.is_action_just_released("jump"):
		Transitioned.emit("Locomote")
		return
	
	# otherwise boost
	if can_boost:
		playerCharacter.apply_central_force(launch_direction)
		return
	
	# otherwise check if we have hit the ground so we can land
	if owner.get_node('GroundCast').is_colliding():
		Transitioned.emit("Locomote")
		return
		
	



func _on_timer_timeout():
	can_boost = false
