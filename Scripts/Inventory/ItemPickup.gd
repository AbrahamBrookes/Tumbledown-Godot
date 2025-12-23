extends Node3D

## The ItemPickup is a Node3D derived object that spawns in the world and can be
## picked up by the player. Set the item_data export var to have the item render
## itself using the data in that resource

class_name ItemPickup

## Set the ItemData to a resource that defines what this item is
@export var item_data: ItemData

## when the player enters the pickup area, pick self up into their inventory
func _on_body_entered(body: Node) -> void:
	# if the collider has a PlayerInventory, add self to it
	var inventory = body.get_node_or_null("PlayerInventory") as PlayerInventory
	if inventory:
		# add_item returns a bool as to wether or not the item was added
		var added: bool = inventory.add_item(item_data)
		# destroy self if we were added
		if added:
			queue_free()
