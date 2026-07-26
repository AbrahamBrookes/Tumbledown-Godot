extends Node

## This node lives on the PlayerCharacter and handles things to do with carrying
## game items that use the Carryable component. I realise carryer is mis-spelled
## which is ok because it's semantically specific
class_name Carryer

## commence picking up an item meaning kick off animations and parenting etc
func pick_up_carryable(carryable: BasicCarryable):
	print(carryable.name)
