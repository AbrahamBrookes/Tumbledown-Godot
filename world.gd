extends Node

## The world is the attachment point into which we load our .tscn scenes for playing in the world.
## This world script handles loading and unloading the world via helper methods that tear down and
## load up the world.
class_name World

## After we load the map we need to load the player character and place them in some location
@export var player_character_scene: String = "res://Scripts/PlayerCharacter/PlayerCharacter.tscn"

## The player instance once spawned
var player_instance: Node3D

## The currently loaded level's file path for instantiating
@export var current_level: String = "res://MainMenu/MainMenu.tscn"

## A reference to the instantiated level
var current_level_instance: Node

## We'll cache the location we want to load into, so callers to load_level can place the player
var player_position: Vector3 = Vector3(0, 0, 50)

## We'll allow the caller to declare if we should load or unload the player character (ie cutscenes, main menu)
var should_load_player_character: bool

## A reference to the loading screen to show/hide while we're loading
@export var loading_screen: Node

## A reference to the loading bar on the loading screen to show level loading progress
@export var loading_bar: ProgressBar

## A reference to the label where we can print loading status text
@export var loading_label: Label

## the path that we are currently loading - blank if nothing is in progress
var loading_path: String = ""

## An array for calculating progress percentage as per ResourceLoader API
var progress := []

## In order to update the progress bare we can use the ResourceLoader API - this is done with a flag
## that we then check in _process
func load_level(path: String, desired_position: Vector3, load_player_character: bool):
	if loading_path != "":
		return # already loading

	loading_path = path
	player_position = desired_position
	should_load_player_character = load_player_character
	progress = []

	ResourceLoader.load_threaded_request(path)
	
	loading_screen.show()
	
	if loading_label:
		loading_label.text = "Loading level"
	
	#var scene: PackedScene = load(path)
	#if scene == null:
		#push_error("Failed to load level at path: %s" % path)
		#return
#
	#var new_level = scene.instantiate()
	#new_level.visible = false
	#add_child(new_level)
#
	## Wait a frame so everything initializes cleanly
	#await get_tree().process_frame
#
	## Swap
	#if current_level_instance:
		#current_level_instance.queue_free()
#
	#new_level.visible = true
	#current_level_instance = new_level
	#current_level = path


func _process(_delta):
	if loading_path == "":
		return

	var status = ResourceLoader.load_threaded_get_status(loading_path, progress)

	if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		loading_screen.show()
		
		if loading_bar and progress.size() > 0:
			loading_bar.value = progress[0] * 100.0

	elif status == ResourceLoader.THREAD_LOAD_LOADED:
		var scene: PackedScene = ResourceLoader.load_threaded_get(loading_path)
		if scene == null:
			push_error("Failed to finalize load: %s" % loading_path)
			loading_path = ""
			return

		var new_level = scene.instantiate()
		new_level.visible = false
		add_child(new_level)

		# Optional: let it initialize one frame
		await get_tree().process_frame

		if current_level_instance:
			current_level_instance.queue_free()

		new_level.visible = true
		current_level_instance = new_level
		current_level = loading_path
		loading_path = ""
		
		place_player()
	
		loading_screen.hide()
		
		## if we're paused, unpause (this node is set to process always)
		get_tree().paused = false

	elif status == ResourceLoader.THREAD_LOAD_FAILED:
		push_error("Failed to load: %s" % loading_path)
		loading_path = ""
	
		loading_screen.hide()
		
## An internal helper to instantiate and place the player pawn
func place_player():
	# if we don't want to place the player, unload the instance so we don't have it floating around
	if !should_load_player_character:
		if player_instance:
			player_instance.queue_free()
			player_instance = null
		
		# bail out so we don't re-load
		return
		
	# place the player at the desired location
	if loading_label:
		loading_label.text = "Placing Player"
		
	# If we haven't yet loaded the player instance, load it
	if not player_instance:
		var player_scene: PackedScene = load(player_character_scene)
		if player_scene == null:
			push_error("Failed to load player scene")
		else:
			player_instance = player_scene.instantiate()
			
		## TODO: deserialize the save file and hydrate the player model here, on first session load
		
	# attach to level
	if player_instance.get_parent():
		player_instance.get_parent().remove_child(player_instance)
		
	current_level_instance.add_child(player_instance)
	player_instance.global_position = player_position
	
	await get_tree().process_frame
