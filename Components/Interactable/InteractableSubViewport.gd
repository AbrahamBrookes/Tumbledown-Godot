extends SubViewport

@export var panel_container: PanelContainer
@export var label: Label

func _ready():
	# Update size whenever the internal UI changes
	update_size()
	# Connect to the label's signal to auto-resize when text changes
	label.item_rect_changed.connect(update_size)

func update_size():
	# Wait one frame for the engine to calculate the new container size
	await get_tree().process_frame
	size = panel_container.get_combined_minimum_size()
