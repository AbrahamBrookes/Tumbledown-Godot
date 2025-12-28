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

## handling player health and damage receival
@export var player_health: PlayerHealth
var is_invincible: bool = false
@export var invincible_timer: Timer
# the damage pushback velocity gets mixed with the state-managed velocity
var pushback_velocity: Vector3 = Vector3.ZERO

## expose the inventory so other scripts can access it
@export var inventory: PlayerInventory

## expose the interactor so other scripts can access it
@export var interactor: Interactor

func _ready() -> void:
	stateMachine.TransitionTo("Locomote")

func _physics_process(delta: float) -> void:
	
	# Decay pushback velocity (friction)
	var pushback_friction = 10.0
	if pushback_velocity.length() < 0.1:
		pushback_velocity = Vector3.ZERO
	else:
		pushback_velocity.x = lerp(pushback_velocity.x, 0.0, pushback_friction * delta)
		pushback_velocity.z = lerp(pushback_velocity.z, 0.0, pushback_friction * delta)

	# use the desired velocity from the current state and mix in pushback
	var state_desired_velocity = stateMachine.current_state.desired_velocity
	var combined_velocity = state_desired_velocity + pushback_velocity
	velocity.x = combined_velocity.x
	velocity.y = combined_velocity.y
	velocity.z = combined_velocity.z
	move_and_slide()

func receive_damage(damage: Damage) -> void:
	if is_invincible:
		return
	is_invincible = true
	invincible_timer.start()

	player_health.remove_health(damage.amount)

	# Damage.source is a node3D - we can use its global_transform to determine
	# the direction of the attack
	var attack_vector = (
		global_transform.origin - damage.source.global_transform.origin
	)
	attack_vector.y = 0
	attack_vector = attack_vector.normalized()

	# push the player back a bit
	pushback_velocity += attack_vector * damage.get_knockback_force()

	# flash the player mesh to indicate damage
	for n in 12:
		mesh.visible = !mesh.visible
		await get_tree().create_timer(0.05).timeout
	mesh.visible = true

func _on_invincibility_timer_timeout() -> void:
	is_invincible = false
