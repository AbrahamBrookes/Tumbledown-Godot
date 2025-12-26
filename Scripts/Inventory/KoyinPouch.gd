extends Node

## The Koyin Pouch simply tracks our Koyins
class_name KoyinPouch

# the number of koyins
@export var koyins: int = 0

# the label in the UI where we show how many koyins we have
@export var label: Label

## add koyins to the pouch
func add_koyins(amount: int):
	koyins += amount
	label.text = str(koyins)
	
## remove koyins from the pouch
func remove_koyins(amount: int):
	koyins -= amount
	label.text = str(koyins)
