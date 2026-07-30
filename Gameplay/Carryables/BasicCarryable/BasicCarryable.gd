extends CharacterBody3D

class_name BasicCarryable

@export var throw_interactable: Interactable

## Physics Settings for throwing
@export var gravity: float = 9.8
@export var friction: float = 3.0 # How fast it slows down on the ground

## Internal movement state
var is_thrown: bool = false

func _physics_process(delta: float) -> void:
	if not is_thrown:
		return

	# 1. Apply gravity while in the air
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		# Apply friction when sliding on the floor
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		velocity.z = move_toward(velocity.z, 0, friction * delta)

	# 2. Move and detect collisions
	var collision: KinematicCollision3D = move_and_collide(velocity * delta)

	# 3. Handle collision response (bouncing or stopping)
	if collision:
		# Simple bounce response based on collision surface normal
		velocity = velocity.bounce(collision.get_normal()) * 0.4
		
		# Stop thrown state if moving extremely slowly after impact
		if velocity.length() < 0.2:
			is_thrown = false
			velocity = Vector3.ZERO

func commence_pickup(interactor: Interactor):
	is_thrown = false
	disable_physics()
	interactor.player_character.carryer.pick_up_carryable(self)

func commence_throw(interactor: Interactor):
	interactor.player_character.carryer.throw(interactor)

func disable_physics():
	$CollisionShape3D.disabled = true
	velocity = Vector3.ZERO
	is_thrown = false

func enable_physics():
	$CollisionShape3D.disabled = false

## Call this when the player actually releases the thrown object
func apply_throw_impulse(impulse_velocity: Vector3) -> void:
	enable_physics()
	velocity = impulse_velocity
	is_thrown = true
