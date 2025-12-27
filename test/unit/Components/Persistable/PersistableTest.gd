extends GutTest

var persistable: Persistable

func before_each():
	persistable = autoqfree(Persistable.new())
	# persistable.uuid_util = preload("res://addons/uuid/uuid.gd") # if needed

func test_generate_new_uuid_sets_guid():
	persistable.guid = ""
	persistable.generate_new_uuid()
	assert_true(persistable.guid != "", "GUID should not be empty after generation")

func test_save_to_disk_sets_data():
	var test_data = {"foo": "bar"}
	persistable.guid = "test-guid"
	persistable.save_to_disk(test_data)
	assert_eq(persistable.data, test_data, "Data should be set after save_to_disk")

func test_ready_pushes_error_on_missing_guid():
	persistable.guid = ""
	persistable._ready()
	assert_push_error("Persistable component is missing a GUID! This will prevent saving/loading working correctly.")

# not going to test the actual read/write to disk functionality here since it's too complex
# and Godot has the authority to say that stuff works correctly
