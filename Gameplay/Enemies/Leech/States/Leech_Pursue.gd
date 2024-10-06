extends State
class_name Leech_Pursue

var target
@export var NavAgent: NavigationAgent3D
@export var movement_speed: float = 5.0
var movement_delta: float
var can_leech_move: bool # when the timer times down, we can move
var leech_jump_location: Vector3 # where the leech will next jump to
@export var leech_jump_length: float = 2.0

func _ready() -> void:
	NavAgent.velocity_computed.connect(Callable(_on_velocity_computed))

func set_movement_target(movement_target: Vector3):
	NavAgent.set_target_position(movement_target)

func _on_velocity_computed(safe_velocity: Vector3):
	owner.velocity = safe_velocity
	owner.move_and_slide()

func Enter(extra_data = null):
	target = extra_data["target"]
	$LeechJumpTimer.start()
	
	leech_jump_location = target.global_position - owner.global_position
	# limit the distance to a jump unit
	leech_jump_location = owner.global_position + leech_jump_location.normalized() * leech_jump_length
	set_movement_target(leech_jump_location)

	# blend our walking animation
	stateMachine.travel("Locomote")
	animTree.set("parameters/StateMachine/Locomote/blend_position", 1)

func Exit():
	pass

func Update(_delta: float):
	pass

func Physics_Update(delta: float):
	# the leech has a jump stop style of movement, so we want to move the actual object
	# at odd times. We have a timer that is the length of time from the start of the animation
	# to the moment the leech should start moving. When that timer times down, we run our actual
	# location transformation in a bit of a snap.

	# get a position between us and the player, but only one unit away from us
	var current_position: Vector3 = owner.global_position
	var direction: Vector3 = (leech_jump_location - current_position).normalized()
	var new_velocity: Vector3 = direction * movement_speed

	# turn and face but only directly in the xz plane
	owner.look_at(owner.global_transform.origin + Vector3(new_velocity.x, 1, new_velocity.z), Vector3.UP)
	
	if not can_leech_move:
		return
		
	if NavAgent.is_navigation_finished():
		$LeechJumpTimer.stop()
		$LeechPauseTimer.start()
		can_leech_move = false
		return
	
	# apply gravity
	new_velocity.y = -9.8
	
	if NavAgent.avoidance_enabled:
		NavAgent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)


func _on_leech_jump_timer_timeout():
	print("_on_leech_jump_timer_timeout")
	can_leech_move = true

# Add a debug sphere at global location.
func draw_debug_sphere(location, size = 0.25, color = Color(1, 0, 0)):
	# Will usually work, but you might need to adjust this.
	var scene_root = get_tree().root.get_children()[0]
	# Create sphere with low detail of size.
	var sphere = SphereMesh.new()
	sphere.radial_segments = 4
	sphere.rings = 4
	sphere.radius = size
	sphere.height = size * 2
	# Bright red material (unshaded).
	var material = StandardMaterial3D.new()
	material.albedo_color = color
	material.flags_unshaded = true
	sphere.surface_set_material(0, material)

	# Add to meshinstance in the right place.
	var node = MeshInstance3D.new()
	node.mesh = sphere
	node.global_transform.origin = location
	scene_root.add_child(node)


func _on_leech_pause_timer_timeout():
	print("_on_leech_pause_timer_timeout")
	Transitioned.emit("Leech_Pursue", {
		target = target
	})
