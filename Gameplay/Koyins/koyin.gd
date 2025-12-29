extends Node3D

# can we be picked up yet?
var can_pick_up: bool = false

func _on_area_3d_body_entered(body: Node3D) -> void:
	if not can_pick_up:
		return
	# if the collider has a KoyinPouch, add a koyin
	var pouch = body.get_node_or_null("KoyinPouch") as KoyinPouch
	if pouch:
		pouch.add_koyins(1)
		queue_free()

# wait a sec before spawning before we can be picked up, so the player can see us
func _on_can_pick_up_timer_timeout() -> void:
	can_pick_up = true

# when we are loot dropped, go up and then settle back down
func loot_dropped() -> void:
	var tween = create_tween()
	tween.tween_property(self, "position:y", position.y + 0.5, 0.6).set_trans(Tween.TransitionType.TRANS_SINE).set_ease(Tween.EaseType.EASE_OUT)
	tween.tween_property(self, "position:y", position.y, 1.5).set_delay(0.3).set_trans(Tween.TransitionType.TRANS_SINE).set_ease(Tween.EaseType.EASE_IN)
