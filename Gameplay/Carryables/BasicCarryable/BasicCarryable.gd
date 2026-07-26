extends StaticBody3D

## This uses an interactable component and some local hard-coupling to allow the
## interactable to tell the player character to pick itself up.
class_name BasicCarryable

## Rig the interactors interact signal up here to call the player character
func commence_pickup(interactor: Interactor):
	interactor.player_character.carryer.pick_up_carryable(self)

## At some poitn we want to switch off collision for the pickupable
func disable_physics():
	$CollisionShape3D.disabled = true
