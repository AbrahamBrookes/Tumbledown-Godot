extends Button

## on click, load the new game map
@export var new_game_map: String = "res://Levels/world.tscn"

func _ready() -> void:
	# TODO: if the new_game_map is invalid, report it
	pass

func _on_pressed() -> void:
	Game.load_level(new_game_map, Vector3(-17.00, 5.0, -30.00), true)
