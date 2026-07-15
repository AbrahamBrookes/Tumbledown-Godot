extends Resource

## The LocationSave just serialises where in the game world the player is - the current map and the players location
class_name LocationSave

## The resource loading path to map that we are in
@export var current_level: String

## Our 3D location in the map
@export var current_location: Vector3

## the gather method hydrates this resource with all the stuff it wants to track from current game state
func gather():
	current_level = Game.world.current_level
	current_location = Game.world.player_instance.global_position

## after we have been data-filled from disk we need to apply our data to the game world
func apply():
	# proxy to the game world loader to load the level
	Game.world.load_level(current_level, current_location, true)
