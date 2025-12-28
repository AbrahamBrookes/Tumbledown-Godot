@tool
extends Node

## The Persistable component is used for saving and loading the state of stuff
## to a save slot. This works by generating its own uuid and taking a string var.
## The string var is handled by the context and whenever it is updated it is
## written to the save file. When the data is loaded, this component emits the
## loaded_from_disk event which can be listened to in order to hydrate state.
## This script is marked with @tool so that we can get some editor loveliness
## a'la the "regenerate guid" button
class_name Persistable

## a signal emitted when this component loads from disk
signal loaded_from_disk(data: String)

## the GUID generated to identify this data in the save slot
@export var guid: String

## the save file we will use to group our data
@export var save_file: String = "default_save"

## the saved data
@export var data: Variant

# on ready, if we don't have a guid generated, break everything
func _ready() -> void:
	if not guid or guid == "":
		push_error("Persistable component is missing a GUID! This will prevent saving/loading working correctly.")
		print("Persistable component is missing a GUID! This will prevent saving/loading working correctly.")

# compute the save path
func _get_save_path() -> String:
	return "%s/%s.save" % [SaveManager.get_save_directory(), save_file]

func generate_new_uuid():
	guid = uuid_util.v4()
	notify_property_list_changed()

# add an editor button to regenerate the UUID
@export_tool_button("Generate UUID")
var new_uuid = generate_new_uuid

# when we load from disk, emit the signal
func load_from_disk() -> void:
	var file = FileAccess.open(_get_save_path(), FileAccess.READ)
	if not file:
		return

	data = file.get_var().get(guid, null)
	emit_signal("loaded_from_disk", data)

# allow callers to save to disk
func save_to_disk(incoming) -> void:
	data = incoming

	var file = null
	var file_path = _get_save_path()
	var dir_path = file_path.get_base_dir()
	# Ensure directory exists
	DirAccess.make_dir_recursive_absolute(dir_path)

	var dict = {}
	# Try to read existing data
	if FileAccess.file_exists(file_path):
		file = FileAccess.open(file_path, FileAccess.READ)
		if file:
			dict = file.get_var()
	
	# Update or add this guid's data
	dict[guid] = data
	
	# Write back the updated dictionary
	file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		file.store_var(dict)
		file.close()
	
# a helper function to clear saved data
func clear_saved_data() -> void:
	var file_path = _get_save_path()
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		if file:
			var dict = file.get_var()
			if dict.has(guid):
				dict.erase(guid)
				file = FileAccess.open(file_path, FileAccess.WRITE)
				if file:
					file.store_var(dict)
					file.close()

# add an editor button to clear saved data
@export_tool_button("Clear Saved Data")
var clear_data = clear_saved_data
