extends Node

## This node lives on the PlayerCharacter and handles things to do with carrying
## game items that use the Carryable component. I realise carryer is mis-spelled
## which is ok because it's semantically specific
class_name Carryer

## a reference back to the player character for routing logic
@export var player_character: DeterministicPlayerCharacter

## The Carryable we are carrying
var target_carryable: BasicCarryable

## we will also be updating the labels on the GameOverlay contextual buttons (ie: "throw")
@export var controls: ControlsContainer

## commence picking up an item meaning kick off animations and parenting etc
func pick_up_carryable(carryable: BasicCarryable):
	target_carryable = carryable as BasicCarryable
	player_character.stateMachine.TransitionTo("PickingUpCarryable", carryable)

## Throw the carryable - note this is called from the Carryable using a hook-up
## Interactor and Interactable rig
func throw(interactor: Interactor):
	if target_carryable:
		# Re-parent object back to the scene root if it was attached to the hand
		target_carryable.reparent(get_tree().current_scene)
		
		# Calculate throw direction and force
		var throw_direction: Vector3 = interactor.player_character.mesh.global_transform.basis.z
		var throw_force: float = 12.0
		
		# Apply impulse to start move_and_collide processing
		target_carryable.apply_throw_impulse(throw_direction * throw_force)
		
		interactor.override_interactable(null)
		
		player_character.stateMachine.TransitionTo("ThrowingCarryable", target_carryable)
	
		target_carryable = null
