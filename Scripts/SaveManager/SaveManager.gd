@tool
extends Node

## The SaveManager is a global autoload we can use to persist game data, start a new game etc. This class
## persists data to disk but it also manages a local cache representation of the save data. During gameplay,
## write to the save cache and read from the save cache so that ie level transitions persist during the
## session, and when the user actually saves the game we persist the cache to disk.

## The save data cache to R/W during gameplay and persist to disk on save
@export var save_cache: GameSave

## The slot that the user is currently playing
var current_slot: int = 1

## Our new game template resource for easy dupe when starting a new game
@export var new_game_template = preload("res://Scripts/SaveManager/NewGameTemplate.tres")

# using the slot, return the path to the save directory
func get_save_directory() -> String:
	return "user://saves/slot_%d/" % [current_slot]

# using the save directory getter, return the full path to the master save file
func get_master_save_file() -> String:
	return get_save_directory() + "master.tres"

## Initialise a new empty save game in the given slot
func new_game(slot: int):
	current_slot = slot
	
	# make sure the directory exists first
	if not DirAccess.dir_exists_absolute(get_save_directory()):
		# This creates the directory/folders automatically if missing
		DirAccess.make_dir_recursive_absolute(get_save_directory())
		
	if FileAccess.file_exists(get_master_save_file()):
		# TODO: show a UI alert and confirm user wants to overwrite
		print("Warning: Overwriting an existing save slot.")
	
	# create the save data and persist it to disk
	save_cache = new_game_template.duplicate(true)
	
	# persist to disk
	var result = ResourceSaver.save(save_cache, get_master_save_file())
	
	if result != OK:
		push_error("Error when creating new game save file: " + error_string(result))
		return
	
	# load it like a regular save
	load_game(slot)

## Save the game by first loading the current save game resource, then overwriting its values
## and then persist the resource to disk
func save_game():
	# check there is a file to save to
	if not ResourceLoader.exists(get_master_save_file()):
		push_error("Cannot save a game without a pre-existing save file!")
		return
	
	# perform any gathers at save time
	save_cache.gather()
	
	# now write cache to disk
	var save_result = ResourceSaver.save(save_cache, get_master_save_file())
	
	# check for issues
	if save_result != OK:
		push_error("Hydrated save data but got an error when saving resource to disk! Game not saved with error: " + save_result)
		return
	
	# saved successfully!
	# TODO: react to successful/failed save in the UI

## load the given slot from disk and hydrate the game state
func load_game(slot: int):
	# set the global slot to the incoming value
	current_slot = slot
	
	# check there is a file to save to
	if not ResourceLoader.exists(get_master_save_file()):
		push_error("Cannot load a game without a pre-existing save file at " + get_master_save_file())
		return
	
	# load the data from that save game and pre-hydrate our save data
	save_cache = ResourceLoader.load(get_master_save_file()) as GameSave
	
	# check the data was loaded from disk properly
	if not save_cache:
		push_error("Loaded save data from disk but resulting data is corrupt or false. Cannot load game!")
		return
	
	# we're good to apply the data from disk to the game state
	save_cache.apply()
