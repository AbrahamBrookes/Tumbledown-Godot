extends Area3D

## This is a test script for getting the water interactable. This script is applied to the water
## meshes in the terrain gridmap TODO: once the map is cemented, use big collision boxes attached to
## a single script so we don't have a bajillion scripts in the game

## when something falls in the water, if it has a 'wettable' component, call its 'fall_in_water()'
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Wettable:
		body.fall_in_water()
	else:
		# Check if any child node is of type Wettable
		for child in body.get_children():
			if child is Wettable:
				child.fall_in_water()
				break
