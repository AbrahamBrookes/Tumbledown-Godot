extends State

## When the player throws a carryable they need to animate the throw
class_name ThrowingCarryable

## A timer that counts down and the we immediately flick to Locomote
@export var transition_timer: Timer

func Enter(_extra_data = null):
	transition_timer.start()

func _on_timer_timeout() -> void:
	Transitioned.emit("Locomote")

## On Exit put your arms down
func Exit():
	state_machine.animTree.set("parameters/CarryingTorsoArms/blend_amount", 0.0)
