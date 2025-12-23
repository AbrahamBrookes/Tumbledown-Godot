@icon("res://Scripts/Inventory/PlayerInventory.svg")

extends Node

## The PlayerInventory holds all of the players collected items. It is a component
## that is attached to the player so it is always loaded in with the player.

class_name PlayerInventory

# the inventory is keyed by ItemData resources, and the value is how many of that item the player has
@export var inventory: Dictionary[String, int] = {}

## Add an item to the inventory, returning a bool as to wether or not we did
func add_item(item: ItemData) -> bool:
	# if the item is stackable and we already have one, don't add it
	if not item.stackable and inventory.get(item.id, 0) > 0:
		return false
	
	# otherwise add the item
	inventory[item.id] = inventory.get(item.id, 0) + item.stack_count
	return true
