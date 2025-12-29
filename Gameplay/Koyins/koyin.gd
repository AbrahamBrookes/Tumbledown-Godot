extends Node3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	# if the collider has a KoyinPouch, add a koyin
	var pouch = body.get_node_or_null("KoyinPouch") as KoyinPouch
	if pouch:
		pouch.add_koyins(1)
		queue_free()

# when we are loot dropped, go up and then settle back down
func loot_dropped() -> void:
	var tween = create_tween()
	tween.tween_property(self, "position:y", position.y + 0.5, 0.6).set_trans(Tween.TransitionType.TRANS_SINE).set_ease(Tween.EaseType.EASE_OUT)
	tween.tween_property(self, "position:y", position.y, 1.5).set_delay(0.3).set_trans(Tween.TransitionType.TRANS_SINE).set_ease(Tween.EaseType.EASE_IN)
