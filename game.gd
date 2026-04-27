extends Node

## This script is autoloaded so you can access it as Game.whatever. Main.gd is loaded as the project
## main scene, and it fills references on the global Game on boot, after which the Game global can
## do things like Game.load_level using its references that have been filled.

var world: World

## proxy load_level to the world's method
func load_level(path: String, desired_position: Vector3, load_player_character: bool):
	if not world:
		push_error("world not loaded into Game gautoload yet")
		return
	
	world.load_level(path, desired_position, load_player_character)
