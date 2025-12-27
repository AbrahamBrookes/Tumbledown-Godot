@tool
extends Node3D

## The LootyChest has an item inside it and can be interacted with via its child
## Interactable component.
class_name LootyChest

## The item inside the chest
@export var loot: ItemData

## The animation player so we can play the open animation
@export var anim: AnimationPlayer

## the interactable allowing us to be opened (for disabling)
@export var interactable: Interactable

## the Persistable component so we can save our open state
@export var persistable: Persistable

# on ready, load our open state
func _ready() -> void:
	## NOTE: we'll change this when we have map transitions working - we can load these when the map boots up
	## instead of stacking up the _ready calls
	persistable.load_from_disk()

# when we are interacted with, open the chest and grant the item (and save state)
func _on_interactable_interacted(interactor: Interactor) -> void:
	anim.play("opening")
	interactor.player_character.stateMachine.travel("OpeningChest")
	interactor.player_character.inventory.add_item(loot)
	interactable.enabled = false

	# save the chests open state using the Persistable component
	persistable.save_to_disk({"is_open": true})

# when the persistable loads we want to update our state and possibly our animation
func _on_persistable_loaded(data: Variant) -> void:
	if data and data.has("is_open") and data["is_open"]:
		anim.play("idle_open")
		interactable.enabled = false
	else:
		anim.play("idle_closed")
		interactable.enabled = true
