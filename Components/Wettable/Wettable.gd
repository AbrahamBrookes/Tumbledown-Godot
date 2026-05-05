extends Node3D

## Use this Wettable component on your minions or anything that needs to have the commonnly known
## water interactions - falling in water, being pushed by water, specifically, this interacts with
## our gridmap_water script TODO: migrate away from gridmap_water when maps are sound
class_name Wettable

## A signal for telling our controller script that we fell in the water
signal fell_in_water

## falling in the water really just triggers our scripts - implement your own logic ie drowning,
## floating, pathing etc in a parent brain script
func fall_in_water():
	fell_in_water.emit()
