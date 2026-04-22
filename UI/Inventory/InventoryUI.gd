extends Control

## This script is the base script for our inventory UI where the player can peruse and use the items
## they have picked up.
class_name InventoryUI


## Listen to our pause_menu action to close the inventory screen. This node is set to process mode
## = WhenPaused, so this code only runs when the game is paused. See the PlayerInventory.gd script
## for how we open the menu
func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause_menu"):
		get_viewport().set_input_as_handled()
		print('sdfdfg')
		hide()
		get_tree().paused = false
