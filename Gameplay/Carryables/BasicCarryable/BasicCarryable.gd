extends CharacterBody3D

## This uses an interactable component and some local hard-coupling to allow the
## interactable to tell the player character to pick itself up.
class_name BasicCarryable

## Every carryable needs to have a throw interactor to allow the player to throw
@export var throw_interactable: Interactable

## Rig the interactors interact signal up here to call the player character
func commence_pickup(interactor: Interactor):
	interactor.player_character.carryer.pick_up_carryable(self)

## When the throw interactable is thrown, route the logic back to the player character
func commence_throw(interactor: Interactor):
	interactor.player_character.carryer.throw(interactor)

## At some poitn we want to switch off collision for the pickupable
func disable_physics():
	$CollisionShape3D.disabled = true
