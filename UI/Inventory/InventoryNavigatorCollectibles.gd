extends Node

## This node exists as a component on the InventoryUI to capture input and allow the user to navigate
## and interact with the inventory. The inventory screen is made up of a couple of different screens
## each for different things - ie one for collectibles, one for quest items, one for usable items.
## This script in particular is just for the collectibles screen which is a GridContainer.
## We track the location of the cursor and react to the same input that the player uses to walk in
## game but instead we move the highlight and "hover" an item.

class_name InventoryNavigatorCollectibles

## Emitted when the cursor exceeds the right of the box
signal exit_right
## Emitted when the cursor exceeds the left of the box
signal exit_left
## Emitted when the cursor exceeds the top of the box
signal exit_top
## Emitted when the cursor exceeds the bottom of the box
signal exit_bottom

## A reference to the grid container rendering our collectibles
@export var grid: GridContainer

## Our GridContainer has a defined size width and height, so we need to track the currently hovered
## coordinates in a vec2. NOTE we are assuming 0, 0 is top left because the index in the gridcontainer
## starts at 0
var current_location: Vector2i = Vector2i(0, 0)

## We need to track the height and width of the GridContainer - this can also be used to set the grid
## dimensions if we ever want to do that I guess
var grid_height : int = 4
var grid_width: int = 10

## we only want to render the cursor if we are active
var should_render_cursor: bool = true

## Listen to input for the sake of navigating
func _unhandled_input(event: InputEvent) -> void:
	# bail out early if we're not supposed to be rendering
	if not should_render_cursor:
		return
	
	if event.is_action_pressed("walk_east"):
		if current_location.x == grid_width - 1 or get_current_index() == grid.get_child_count() - 1:
			#should_render_cursor = false
			exit_right.emit()
		else:
			current_location.x = current_location.x + 1
		render_cursor()
		
	if event.is_action_pressed("walk_west"):
		if current_location.x == 0:
			#should_render_cursor = false
			exit_left.emit()
		else:
			current_location.x = current_location.x - 1
		render_cursor()
		
	if event.is_action_pressed("walk_north"):
		if current_location.y == 0:
			#should_render_cursor = false
			exit_top.emit()
		else:
			current_location.y = current_location.y - 1
		render_cursor()
		
	if event.is_action_pressed("walk_south"):
		if current_location.y == grid_height - 1 or get_current_index() == grid.get_child_count() - 1:
			#should_render_cursor = false
			exit_bottom.emit()
		else:
			current_location.y = current_location.y + 1
		render_cursor()
	

## Rendering the cursor displays where we are currently hovering
func render_cursor():
	get_viewport().set_input_as_handled()
	
	# un-highlight all ItemSlots in the grid
	for child in grid.get_children():
		if child is ItemSlot:
			child.highlight(false)
		
	# bail out early if we're not supposed to be rendering
	if not should_render_cursor:
		return
		
	var current_index = get_current_index()
	
	# get the slot there
	var slot = grid.get_child(current_index) as ItemSlot
	
	## we are expecting the slot to be an ItemSlot
	if slot == null:
		return
	
	# highlight the slot
	slot.highlight(true)
	
## A helpful getter for our current index
func get_current_index() -> int:
	# gridcontainers don't have knowledge of x and y they just store a list of slots so we need to
	# convert from our x and y to a total, which is columns * x + y (*x because the grid is horizontal
	# in this instance)
	var index = (grid.columns * current_location.y) + current_location.x
	
	# clamp to the grid max so we don't overflow the index
	index = clamp(index, 0, grid.get_child_count() - 1)
	
	return index
