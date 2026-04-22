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

## Rendering the slot means grabbing the image and slapping it in the texture rect
func render():
	image.texture = item_data.icon
	qty_label.text = str(quantity)

## Setting an item assigns our item data and then renders
func set_item(item: ItemData, qty: int):
	item_data = item
	quantity = qty
	render()
