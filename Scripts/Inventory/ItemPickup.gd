extends Node3D

## The ItemPickup is a Node3D derived object that spawns in the world and can be
## picked up by the player. Set the item_data export var to have the item render
## itself using the data in that resource. When the player collides with this object
## it will be added to their inventory as an ItemData record. When the player drops
## that ItemData from their inventory, the ItemData's world_object PackedScene
## will be instantiated to create a new ItemPickup in the world. So and ItemPickup
## should generally have a reference to an ItemData resource, and that ItemData resource
## should have a reference back to the ItemPickup's PackedScene as its world_object.
## Each item in the game is a clone of this ItemPickup scene with different ItemData resources.
class_name ItemPickup

## Set the ItemData to a resource that defines what this item is
@export var item_data: ItemData

# can we be picked up yet?
var can_pick_up: bool = false

# wait a sec before spawning before we can be picked up, so the player can see us
func _on_can_pick_up_timer_timeout() -> void:
	can_pick_up = true

## spawn the world_object from the item_data as a child to represent the item visually
func render() -> void:
	if item_data and item_data.world_object:
		var world_object_instance = item_data.world_object.instantiate()
		add_child(world_object_instance)

# whenever this enters the scene tree, render self
func _ready() -> void:
	render()

## when the player enters the pickup area, pick self up into their inventory
func _on_body_entered(body: Node) -> void:
	if not can_pick_up:
		return
	# if the collider has a PlayerInventory, add self to it
	var inventory = body.get_node_or_null("PlayerInventory") as PlayerInventory
	if inventory:
		# add_item returns a bool as to wether or not the item was added
		var added: bool = inventory.add_item(item_data)
		# destroy self if we were added
		if added:
			queue_free()

## since this can be spawned into the world as loot, we might want to do
## some special effects when we are loot dropped
func loot_dropped() -> void:
	# animate a little hop when we are dropped - in order to add custom loot drop effects
	# you will need to extend this class and override this function
	var tween = create_tween()
	tween.tween_property(self, "position:y", position.y + 0.5, 0.6).set_trans(Tween.TransitionType.TRANS_SINE).set_ease(Tween.EaseType.EASE_OUT)
	tween.tween_property(self, "position:y", position.y, 1.5).set_delay(0.3).set_trans(Tween.TransitionType.TRANS_SINE).set_ease(Tween.EaseType.EASE_IN)
