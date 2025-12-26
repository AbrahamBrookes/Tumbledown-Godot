extends Node

## The Interactable is a component you can add to any object in the world in order
## to make it interact-with-able. This manages a little popup that hovers over
## the object when the player has it listed as their current interactable. Set
## the word you want the popup to say and listen to the "interacted" signal to
## run your logic when the player interacts.
class_name Interactable

signal interacted(interactor: DeterministicPlayerCharacter)

## the word to show in the interact popup
@export var verb: String

## the label into which we will inject the aforementioned word
@export var label: Label

# on ready, fill the label with the text
func _ready() -> void:
	label.text = verb
