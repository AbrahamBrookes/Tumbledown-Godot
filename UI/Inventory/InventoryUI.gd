extends Control

## This script is the base script for our inventory UI where the player can peruse and use the items
## they have picked up.
class_name InventoryUI

## The item slot .tscn we will instantiate when rendering
@export var item_slot_template: PackedScene

## The grid container into which we render ItemSlots
@export var grid: GridContainer

## Listen to our pause_menu action to close the inventory screen. This node is set to process mode
## = WhenPaused, so this code only runs when the game is paused. See the PlayerInventory.gd script
## for how we open the menu
func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause_menu"):
		get_viewport().set_input_as_handled()
		hide()
		get_tree().paused = false

## Reveal is called instead of a simple show() so we can handle rendering or animations
func reveal(inventory: PlayerInventory):
	show()
	render(inventory.inventory)

## Rendering takes the Inventory dictionary (which is key = ItemData id's and value = quantity) and
## renders item slots into the UI
func render(inventory: Dictionary[String, int]):
	# Clear existing UI first
	for child in grid.get_children():
		child.queue_free()
		
	# Build new slots
	for item_id in inventory.keys():
		var quantity: int = inventory[item_id]

		# Instantiate slot
		var slot = item_slot_template.instantiate() as ItemSlot
		grid.add_child(slot)

		# Resolve item data from our global ItemRegistry
		var item_data: ItemData = ItemRegistry.get_item_data(item_id)

		# Pass data into the slot
		slot.set_item(item_data, quantity)
		
