extends Resource

## The ItemDatabase is the full list of all possible items in our game and their related ItemData.
## This is used so we can take an ItemData id and return the appropriate ItemData resource.
class_name ItemDatabase

## The database itself is built in the editor by manually adding items as you go
@export var database: Dictionary[String, ItemData]
