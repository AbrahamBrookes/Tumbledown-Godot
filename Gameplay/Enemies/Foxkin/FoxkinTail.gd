extends Node

## The foxkin have a floaty tail that we want to override using in-game logic instead of keyframe animations
class_name FoxkinTail

## The Skeleton3D powering the tail mesh
@export var skeleton: Skeleton3D

## The body node to track (e.g., CharacterBody3D or RigidBody3D)
@export var target_body: Node3D

## How fast the tail snaps back to its target position
@export var wiggle_speed: float = 5.0

## Multiplier for how dramatically the tail reacts to movement
@export var floatiness: float = 2.0

var last_position: Vector3

func _ready() -> void:
	# Initialize last_position so the first frame doesn't cause a massive jump
	if target_body:
		last_position = target_body.global_position

func _physics_process(delta: float) -> void:
	#print(last_position)
	if not target_body or not skeleton:
		return
		
	# 1. Calculate the frame-by-frame movement vector
	var current_position = target_body.global_position
	var body_velocity = current_position - last_position
	
	# 2. Calculate dynamic rotations based on movement axes
	# Bouncing UP/DOWN (Y) makes the tail rotate around the X-axis (pitch)
	var pitch = -body_velocity.y * floatiness
	
	# Moving LEFT/RIGHT (X) makes the tail rotate around the Y-axis (yaw)
	var yaw = -body_velocity.x * floatiness
	
	# Combine into a target Quaternion
	# Note: Depending on your Blender export orientation, you may need to swap these axes
	var target_rot = Quaternion.from_euler(Vector3(pitch, yaw, 0.0))
	
	# 3. Loop through the tail bones and apply the lagging rotation
	for bone_idx in range(1, 4):
		var current_rot = skeleton.get_bone_pose_rotation(bone_idx)
		# Bone 1 gets 1x intensity, Bone 2 gets 2x intensity, Bone 3 gets 3x intensity
		var bone_factor = float(bone_idx) 
		var progressive_rot = Quaternion.from_euler(Vector3(pitch * bone_factor * 100, yaw * bone_factor * 100, yaw * bone_factor * 100))

		var new_rot = current_rot.slerp(progressive_rot, delta * wiggle_speed)
		skeleton.set_bone_pose_rotation(bone_idx, new_rot)
	
	# 4. CRITICAL: Store the current position for the next frame's calculation
	last_position = current_position
