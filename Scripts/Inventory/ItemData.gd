extends Resource

class_name ItemData

# id must have no spaces as it is used as a key - letters numbers and underscores only!
@export var id: String = ""

@export var name: String = ""
@export var flavour_text: String = ""
@export var icon: Texture2D = null
@export var world_object: PackedScene = null
@export var stackable: bool = false
@export var stack_count: int = 0
@export var monetary_value: int = 0
