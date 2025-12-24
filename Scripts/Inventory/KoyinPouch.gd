extends Node

class_name KoyinPouch

## The Koyin Pouch simply tracks our Koyins

@export var koyins : int = 0

## add koyins to the pouch
func add_koyins(amount: int):
	koyins += amount
	
## remove koyins from the pouch
func remove_koyins(amount: int):
	koyins -= amount
