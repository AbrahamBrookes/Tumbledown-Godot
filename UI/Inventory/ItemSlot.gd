extends AspectRatioContainer

## The ItemSlot is a UI control that displays a given ItemData, rendering its icon to the ImageTexture
class_name ItemSlot

## The ItemData containing the item - set dynamically
@export var item_data: ItemData

## the quantity to display
var quantity: int

## The TextureRect we are rendering the icon into
@export var image: TextureRect

## The label we print the quantity to
@export var qty_label: Label

## The PanelContainer that provides the box styling, for highlights
@export var panel_box: PanelContainer

## In order to show a highlight we want a non-highlighted and a highlighted style theme
## that we swap out as the user navigates item slots

## The style to use when the slot is highlighted
@export var style_highlight: StyleBoxFlat

## The style to use when the slot is not highlighted
@export var style_idle: StyleBoxFlat

## Rendering the slot means grabbing the image and slapping it in the texture rect
func render():
	image.texture = item_data.icon
	qty_label.text = str(quantity)

## Setting an item assigns our item data and then renders
func set_item(item: ItemData, qty: int):
	item_data = item
	quantity = qty
	render()

## When the user is hovering the slot, highlight it. Pass a bool to toggle
func highlight(enabled: bool):
	panel_box.add_theme_stylebox_override(
		"panel",
		style_highlight if enabled else style_idle
	)
