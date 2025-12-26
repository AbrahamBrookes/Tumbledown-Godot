extends CharacterBody3D
class_name DeterministicPlayerCharacter

# The DeterministicPlayerCharacter is a player controller script that is not physics-driven. Instead
# of using a RigidBody3D and applying forces, we are using a PlayerCharacter3D and driving movement
# using move_and_slide.

# since we are rotating the mesh separately we need a reference to it
@export var mesh: Node3D
# child scripts and the state machine require a reference to the anim tree
@export var animTree : AnimationTree
# the state machine is our custom rolled state manager
@export var stateMachine : StateMachine

# the team this entity is on - 1 = player, 2 = enemy
var team = 1

@export var move_speed := 4.0
@export var acceleration := 10.0
@export var deceleration := 12.0
@export var rotation_speed := 10.0
@export var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var player_health: PlayerHealth

var input_dir: Vector2
var move_dir: Vector3
var target_velocity := Vector3.ZERO

func _ready() -> void:
	stateMachine.TransitionTo("Locomote")

func receive_damage(damage: Damage) -> void:
	player_health.remove_health(damage.amount)
