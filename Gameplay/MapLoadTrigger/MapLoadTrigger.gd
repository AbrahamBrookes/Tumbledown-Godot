extends Area3D

## A simple trigger that will load the given map and meta params. Note this is set to only overlap
## on the player characters layer (3)

## the map we will load
@export var level: String

## the meta params for the load level call
@export var location: Vector3 = Vector3(10, 10, 10)
@export var load_character: bool = true


func _on_area_3d_body_entered(body: Node3D) -> void:
	Game.load_level(level, location, load_character)
	
