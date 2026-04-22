@icon("res://Scripts/Inventory/PlayerInventory.svg")

extends Node

## The PlayerInventory holds all of the players collected items. It is a component
## that is attached to the player so it is always loaded in with the player.

class_name PlayerInventory

# the inventory is keyed by ItemData resources, and the value is how many of that item the player has
@export var inventory: Dictionary[String, int] = {}

# the inventory UI is the view we see when we open the inventory
@export var inventory_ui: Control

## Add an item to the inventory, returning a bool as to wether or not we did
func add_item(item: ItemData) -> bool:
	# if the item is stackable and we already have one, don't add it
	if not item.stackable and inventory.get(item.id, 0) > 0:
		return false
	
	# otherwise add the item
	inventory[item.id] = inventory.get(item.id, 0) + item.stack_count
	return true

## Listen to our pause_menu action to open the inventory screen. This node is a child of the player
## character which has process mode pausable. So pressing pause while playing will fire this code,
## but once the game is paused, this code won't run, so closing the inventory is handled in the
## inventory UI code, which only runs when the game _is_ paused (process mode = WhenPaused)
func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause_menu"):
		get_viewport().set_input_as_handled()
		inventory_ui.show()
		get_tree().paused = true
