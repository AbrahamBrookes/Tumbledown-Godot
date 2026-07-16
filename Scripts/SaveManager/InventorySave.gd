extends Resource

## InventorySave persists data about the players inventory specifically
class_name InventorySave

## How many koyins do we have?
@export var num_koyins: int

## Gather the game data and stash it in the resource ready for serialisation
func gather():
	num_koyins = Game.world.player_instance.koyin_pouch.koyins
	print("koyins: %d" % num_koyins)

## Apply the loaded resource values to the instances in game
func apply():
	pass
	## commenting out for now until I fix the boot order - player instance is not ready here
	#Game.world.player_instance.koyin_pouch.koyins = num_koyins
