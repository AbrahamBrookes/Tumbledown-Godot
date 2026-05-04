extends Button

## on click, load the new game map
@export var new_game_map: String = "res://Levels/world.tscn"


func _on_pressed() -> void:
	Game.load_level(new_game_map, Vector3(-10.00, 5.0, -20.00), true)
