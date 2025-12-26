extends Node3D

## The LootyChest has an item inside it and can be interacted with via its child
## Interactable component.
class_name LootyChest

## The item inside the chest
@export var loot: ItemData

## The animation player so we can play the open animation
@export var anim: AnimationPlayer

func _on_interactable_interacted(interactor: DeterministicPlayerCharacter) -> void:
	interactor.stateMachine.travel("OpeningChest")
	interactor.inventory.add_item(loot)
