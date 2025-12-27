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

func _on_interactable_interacted(interactor: Interactor) -> void:
	anim.play("opening")
	interactor.player_character.stateMachine.travel("OpeningChest")
	interactor.player_character.inventory.add_item(loot)
	interactable.enabled = false
