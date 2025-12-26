@icon("res://Scripts/Health/heart-full.png")

extends Node

## the PlayerHealth is a self-contained component that handles tracking the health
## of the player and updating the in-game UI controls displaying health. We have
## a max health value which informs the UI how many hearts to display total, and
## then we have the current health values which tells the UI how many hearts to
## fill. Health is an integer and each heart has four health points. As the health
## is drained, we swap out the texture on the heart to show 3 quarters, half, one
## quarter, empty. When we reach zero health, we emit a signal.

class_name PlayerHealth

signal health_depleted

## the players current max health - we have 22 hearts with 4 points each so the
## max max health is 88.
@export var max_health: int

## the players current health value
@export var current_health: int

## the UI control for displaying hearts - this is a GridContainer with 22 child
## TextureRect nodes representing each heart.
@export var hearts_container: GridContainer

## the five heart textures we will swap between based on health, preloaded
var heart_textures: Array[Texture2D] = [
	preload("res://Scripts/Health/heart-empty.png"),
	preload("res://Scripts/Health/heart-one-quarter.png"),
	preload("res://Scripts/Health/heart-half.png"),
	preload("res://Scripts/Health/heart-three-quarters.png"),
	preload("res://Scripts/Health/heart-full.png")
]

## on ready, update the UI to match our starting health values
func _ready():
	update_max_health_ui()
	update_hearts_ui()

## a function to remove some health
func remove_health(amount: int):
	current_health -= amount
	
	if current_health < 1:
		emit_signal("health_depleted")
		current_health = 0

	update_hearts_ui()

## a function to add some health
func add_health(amount: int):
	current_health += amount

	if current_health > max_health:
		current_health = max_health

	update_hearts_ui()

## a function to update the hearts UI based on the current health value
func update_hearts_ui():
	var health_per_heart = 4
	var total_hearts = hearts_container.get_child_count()

	for i in range(total_hearts):
		var heart_node = hearts_container.get_child(i) as TextureRect
		var heart_health = current_health - (i * health_per_heart)
		
		if heart_health >= 4:
			heart_node.texture = heart_textures[4]
		elif heart_health == 3:
			heart_node.texture = heart_textures[3]
		elif heart_health == 2:
			heart_node.texture = heart_textures[2]
		elif heart_health == 1:
			heart_node.texture = heart_textures[1]
		else:
			heart_node.texture = heart_textures[0]

## a function to hide the hearts that are beyond our max health
func update_max_health_ui():
	var health_per_heart = 4
	var total_hearts = hearts_container.get_child_count()
	var hearts_to_show = int(ceil(float(max_health) / float(health_per_heart)))

	for i in range(total_hearts):
		var heart_node = hearts_container.get_child(i) as TextureRect
		
		if i < hearts_to_show:
			heart_node.visible = true
		else:
			heart_node.visible = false
