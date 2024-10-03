extends Node3D

signal switch_pressed

@onready var switch_mesh: AnimatableBody3D = $switch
var tween: Tween = create_tween()

# for duck-typing's sake, provide a 'pressed' signal - other scripts can call this whenever they want
func pressed():
	emit_signal("switch_pressed")

func depress_switch():
	var tween = get_tree().create_tween()
	tween.tween_property($switch, "position", Vector3(0, 10, 0), 1)


