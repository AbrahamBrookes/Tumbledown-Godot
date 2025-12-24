extends Node3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	# if the collider has a KoyinPouch, add a koyin
	var pouch = body.get_node_or_null("KoyinPouch") as KoyinPouch
	if pouch:
		pouch.add_koyins(1)
		queue_free()
