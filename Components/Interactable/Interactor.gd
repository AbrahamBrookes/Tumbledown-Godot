extends Node3D

## The Interactor works in concert with the Interactable component. This script
## has a collision shape assigned and internally tracks a current_interactable
## var. When we have a current_interactable we toggle on that interactable's
## display label and when the user interacts we tell the Interactable to fire
## it's "interacted" signal, which kicks off whatever logic is there locally.
class_name Interactor

## the area that will be used to track the current interactable
@export var trigger: Area3D

## a list of interactables currently in range
var interactables: Array = []

## the currently focussed Interactable
var current_interactable: Interactable

## the player character using this interactor
@export var player_character: DeterministicPlayerCharacter

# When we have too many interactables in range we pick the one that is _most_ in front of the player
func pick_interactable() -> void:
	var best_interactable: Interactable
	var best_dot: float = -1.0
	var forward: Vector3 = -global_transform.basis.z.normalized()
	var origin: Vector3 = global_transform.origin
	
	for interactable in interactables:
		# skip disabled interactables
		if not interactable.enabled:
			continue

		var to_interactable: Vector3 = (interactable.global_transform.origin - origin).normalized()
		var dot: float = forward.dot(to_interactable)
		if dot > best_dot:
			best_dot = dot
			best_interactable = interactable
			
	# if the interactable has changed, hide the label on the old one
	if best_interactable != current_interactable and current_interactable:
		current_interactable.hide_label()
	# show the label on the new interactable
	if best_interactable and best_interactable != current_interactable:
		best_interactable.show_label()

	current_interactable = best_interactable

# when a body enters our trigger area, check if it's an interactable and add it to our list
func _on_trigger_body_entered(body: Node) -> void:
	var interactable = body.owner.get_node_or_null("Interactable")
	if interactable:
		interactables.append(interactable)

# when a body exits our trigger area, check if it's an interactable and remove it from our list
func _on_trigger_body_exited(body: Node) -> void:
	var interactable = body.owner.get_node_or_null("Interactable")
	if interactable:
		# hide the label
		interactable.hide_label()

		# if it was our current interactable, clear that
		if interactable == current_interactable:
			current_interactable = null

		# remove it from our list
		interactables.erase(interactable)

func _process(_delta: float) -> void:
	# pick the best interactable from our list
	pick_interactable()

# when the player presses the interact action, call interact on the current interactable
func interact() -> void:
	if current_interactable:
		current_interactable.interact(self)
