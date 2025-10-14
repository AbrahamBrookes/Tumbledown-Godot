extends EditorPlugin

var button: Button

func _enter_tree():
	button = Button.new()
	button.text = "Render High-Res"
	button.pressed.connect(_on_button_pressed)
	add_control_to_container(CONTAINER_SPATIAL_EDITOR_MENU, button)

func _exit_tree():
	remove_control_from_container(CONTAINER_SPATIAL_EDITOR_MENU, button)
	button.queue_free()

func _on_button_pressed():
	var scene_path := get_editor_interface().get_edited_scene_root().scene_file_path
	if scene_path.is_empty():
		printerr("No scene open to render.")
		return

	var PackedSceneClass := load(scene_path)
	if PackedSceneClass == null:
		printerr("Couldn't load scene.")
		return

	var scene: Node = PackedSceneClass.instantiate()

	var sub_viewport := SubViewport.new()
	sub_viewport.size = Vector2i(3840, 2160)
	sub_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	sub_viewport.render_target_v_flip = true

	sub_viewport.add_child(scene)
	add_child(sub_viewport)

	await get_tree().process_frame

	var img := sub_viewport.get_texture().get_image()
	img.save_png("res://high_res_render.png")
	print("✅ Render saved to res://high_res_render.png")

	sub_viewport.queue_free()
