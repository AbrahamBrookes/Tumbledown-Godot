extends Node

## This script is added as a global and simply provides a global singleton access to our ItemDatabase
## resource file. Edit the ItemDatabase.tres by double clicking it in order to add/remove ItemData
## and then look up items like so: ItemRegistry.get_item_data("dino_bomb") to retrieve the DinoBomb
## resource file that is of type ItemData

var item_database: ItemDatabase

func _ready():
	item_database = preload("res://Scripts/Inventory/ItemDatabase.tres")
	
## given an item id (string) return the ItemData resource from our database
func get_item_data(id: String) -> ItemData:
	var item_data = item_database.database.get(id)

	# if for some reason we don't find the item data, chuck a wobbly
	assert(item_data != null, "Could not find item data by id %s" % id)
	
	return item_data
