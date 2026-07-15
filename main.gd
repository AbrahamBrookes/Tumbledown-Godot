extends Node

## This is the main scene script which is the entry point of the entire game. This is the main scene
## in the project settings so this script is loaded on game boot and persists for the entire game
## session.


## The currently loaded level's file path for instantiating
@export var main_menu_resource_path: String = "res://UI/MainMenu/MainMenu.tscn"

## A reference to the world which is the anchor point for loaded scenes
@export var world: World

## on ready, load the main menu scene into world
func _ready() -> void:
	Game.world = world
	Game.load_level(main_menu_resource_path, Vector3.ZERO, false)
