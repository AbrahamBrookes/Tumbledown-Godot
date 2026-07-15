extends Resource

## The GameSave resource is the master save file holding sub-resources for other data
class_name GameSave

## sub-saves are explained in their resource classes
@export var location_data: LocationSave
@export var quest_data: QuestSave
@export var inventory_data: InventorySave

## An entrypoint for applying save data to the game world
func apply():
	location_data.apply()

## An entrypoint for gathering game state when persisting data
func gather():
	location_data.gather()
