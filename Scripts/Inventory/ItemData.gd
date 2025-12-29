extends Resource

class_name ItemData

# id must have no spaces as it is used as a key - letters numbers and underscores only!
@export var id: String = ""

@export var name: String = ""
@export var flavour_text: String = ""
@export var icon: Texture2D = null
@export var stackable: bool = false
@export var stack_count: int = 0
@export var monetary_value: int = 0

## The world_object is used when dropping the item into the world as a pickup.
## It will need to contain a reference back to this ItemData resource so the
## ItemPickup can add this item data back to the player's inventory when picked up.
@export var world_object: PackedScene = null
