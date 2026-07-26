extends Node

## This node lives on the PlayerCharacter and handles things to do with carrying
## game items that use the Carryable component. I realise carryer is mis-spelled
## which is ok because it's semantically specific
class_name Carryer

## a reference back to the player character for routing logic
@export var player_character: DeterministicPlayerCharacter

## The Carryable we are carrying
var target_carryable: BasicCarryable

## commence picking up an item meaning kick off animations and parenting etc
func pick_up_carryable(carryable: BasicCarryable):
	target_carryable = carryable as BasicCarryable
	player_character.stateMachine.TransitionTo("PickingUpCarryable", carryable)
