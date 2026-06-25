extends Node
class_name PlayerCameraAutoPeek

## The camera that we will move about
@export var camera: Camera3D

## The player character we are tracking and reading velocity from
@export var player: CharacterBody3D

## The raycast tracking obstructions
@export var ray: RayCast3D

@export_group("Distance & Scaling Profiles")
## Profile mapping player speed factor (0.0 to 1.0) to zoom out behavior. 
## Flat line = constant distance. S-curve = smooth ease-in/out zoom.
@export var zoom_curve: Curve

## Profile mapping player speed factor (0.0 to 1.0) to look-ahead translation.
## Steeper curve at the beginning means camera jumps ahead quickly on initial movement.
@export var look_ahead_curve: Curve

@export_group("Distance Settings")
## The closest the camera gets when the player is standing still
@export var min_distance: float = 6.0
## The furthest the camera zooms out when the player is sprinting
@export var max_distance: float = 10.0
## The player speed at which max zoom out is achieved
@export var max_speed_threshold: float = 8.0

@export_group("Look Ahead Settings")
## How far ahead of the player the camera should peer when moving at max speed
@export var max_look_ahead_distance: float = 2.5
## How fast the camera shifts its look-ahead target (lower = smoother)
@export var look_ahead_lerp_speed: float = 0.05

@export_group("Collision Peek Settings")
## The standard angle of the camera looking down (e.g., 45 or 55 degrees)
@export var camera_angle_degrees: float = 45.0
## How quickly the camera angles and moves up to peek over a wall
@export var peek_lerp_speed: float = 0.15

# Internal tracking variables
var current_desired_distance: float = 6.0
var current_look_ahead: Vector3 = Vector3.ZERO

func _ready() -> void:
	current_desired_distance = min_distance
	if camera:
		camera.global_rotation = Vector3(deg_to_rad(-camera_angle_degrees), 0.0, 0.0)

func _physics_process(delta: float) -> void:
	if not camera or not player or not ray:
		return

	# 1. Calculate Player Speed Ratio (0.0 = stopped, 1.0 = top threshold speed)
	var horizontal_velocity: Vector3 = Vector3(player.velocity.x, 0.0, player.velocity.z)
	var current_speed: float = horizontal_velocity.length()
	var move_direction: Vector3 = horizontal_velocity.normalized()
	
	var speed_ratio: float = clamp(current_speed / max_speed_threshold, 0.0, 1.0)

	# 2. Map speed to target distance using the Curve
	var zoom_influence: float = speed_ratio
	if zoom_curve:
		zoom_influence = zoom_curve.sample(speed_ratio)
	
	# Interpolate using the curve factor
	var target_distance: float = lerp(min_distance, max_distance, zoom_influence)
	current_desired_distance = lerp(current_desired_distance, target_distance, 0.05)

	# 3. Calculate Look-Ahead Offset using the Curve
	var look_ahead_influence: float = speed_ratio
	if look_ahead_curve:
		look_ahead_influence = look_ahead_curve.sample(speed_ratio)
		
	var target_look_ahead: Vector3 = move_direction * (max_look_ahead_distance * look_ahead_influence)
	current_look_ahead = current_look_ahead.lerp(target_look_ahead, look_ahead_lerp_speed)

	# 4. Define the tracking center
	var player_center: Vector3 = player.global_position + Vector3(0.0, 1.0, 0.0)
	var camera_target_focus: Vector3 = player_center + current_look_ahead
	
	# 5. Calculate the IDEAL default position (Back and Up)
	var angle_rad = deg_to_rad(camera_angle_degrees)
	var default_offset = Vector3(
		0.0,
		current_desired_distance * sin(angle_rad),
		current_desired_distance * cos(angle_rad)
	)
	var ideal_camera_pos: Vector3 = camera_target_focus + default_offset

	# 6. Position the RayCast
	ray.global_position = camera_target_focus
	ray.target_position = ray.to_local(ideal_camera_pos)
	ray.force_raycast_update()

	var final_target_pos: Vector3 = ideal_camera_pos
	var is_peeking: bool = false

	# 7. Collision Peek Logic
	if ray.is_colliding():
		is_peeking = true
		var hit_point: Vector3 = ray.get_collision_point()
		
		final_target_pos.z = hit_point.z + 0.2
		var forced_z_reduction = ideal_camera_pos.z - final_target_pos.z
		final_target_pos.y = ideal_camera_pos.y + (forced_z_reduction * tan(angle_rad))

	# 8. Smoothly translate the camera position
	var current_position_lerp = peek_lerp_speed if is_peeking else 0.1
	camera.global_position = camera.global_position.lerp(final_target_pos, current_position_lerp)
	
	# 9. Dynamic Rotation Blending
	if is_peeking:
		var current_rotation = camera.global_rotation
		camera.look_at(camera_target_focus)
		camera.global_rotation.x = lerp_angle(current_rotation.x, camera.global_rotation.x, peek_lerp_speed)
		camera.global_rotation.y = 0.0 
		camera.global_rotation.z = 0.0
	else:
		var target_pitch = deg_to_rad(-camera_angle_degrees)
		camera.global_rotation.x = lerp_angle(camera.global_rotation.x, target_pitch, peek_lerp_speed)
		camera.global_rotation.y = 0.0
		camera.global_rotation.z = 0.0
