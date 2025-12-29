extends Node3D

## The LootDropper drops loot! It has a dictionary of possible loot to drop,
## keyed by drop chance (0-1). When the drop() function is called we roll a
## random number and see what loot to drop. The loot is then spawned into the
## world at the LootDropper's position.
class_name LootDropper

## An array of possible loot, keyed by the drop chance 0-1
@export var available_loot: Dictionary[float, PackedScene] = {}

func drop():
	var roll := randf()
	for chance in available_loot.keys():
		if roll <= chance:
			var loot: PackedScene = available_loot[chance]
			var loot_instance = loot.instantiate()
			# set the position to our position
			loot_instance.global_transform.origin = global_transform.origin
			# add to the scene tree
			get_tree().current_scene.add_child(loot_instance)
			
			# if the loot has a loot drop effect, run it
			if loot_instance.has_method("loot_dropped"):
				loot_instance.loot_dropped()

	return null
