extends MarginContainer

## The controls container has the controller butons and labels saying what will
## happen if the player presses that button. This changes contextually ie "lift"
## or "talk". In order to route logic, this script provides helpers to set the
## labels depending on context. Maybe we'll do some animations as well.

class_name ControlsContainer

## the Labels for each of our contextual buttons
@export var a_label: Label
@export var b_label: Label

## set the A button label
func set_a_button(content: String) -> void:
	a_label.text = content

## set the B button label
func set_b_button(content: String) -> void:
	b_label.text = content
	
