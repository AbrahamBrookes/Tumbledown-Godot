@tool
extends Node

## the SaveManager is a global singleton that, at time of writing, simply tracks
## which save slot we currently have active

var current_slot: int = 1

# using the slot, return the path to the save directory
func get_save_directory() -> String:
	return "user://saves/slot_%d/" % [current_slot]
