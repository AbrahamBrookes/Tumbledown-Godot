extends Node

## The Koyin Pouch simply tracks our Koyins
class_name KoyinPouch

# the number of koyins
@export var koyins: int = 0

# the label in the UI where we show how many koyins we have
@export var label: Label

## on ready, load the koyins from our save manager
func _ready():
	koyins = SaveManager.save_cache.inventory_data.num_koyins
	update_label()

## add koyins to the pouch
func add_koyins(amount: int):
	koyins += amount
	update_label()
	
## remove koyins from the pouch
func remove_koyins(amount: int):
	koyins -= amount
	update_label()

## update the UI label
func update_label():
	label.text = str(koyins)
	
