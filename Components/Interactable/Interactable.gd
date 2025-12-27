extends Node

## The Interactable is a component you can add to any object in the world in order
## to make it interact-with-able. This manages a little popup that hovers over
## the object when the player has it listed as their current interactable. Set
## the word you want the popup to say and listen to the "interacted" signal to
## run your logic when the player interacts.
class_name Interactable

signal interacted(interactor: Interactor)

## the word to show in the interact popup
@export var verb: String

## the label into which we will inject the aforementioned word
@export var label: Label

## the UI popup thingy for hiding
@export var popup: Sprite3D

## conditionally enable or disable this interactable
@export var enabled: bool = true

# on ready, fill the label with the text
func _ready() -> void:
	label.text = verb
	popup.visible = false

# a callable for interactors to trigger that signal
func interact(interactor: Interactor) -> void:
	if not enabled:
		return

	emit_signal("interacted", interactor)

# hide and show the label
func show_label() -> void:
	# don't show the label if the interactable is disabled
	if not enabled:
		return
	popup.visible = true

func hide_label() -> void:
	popup.visible = false
