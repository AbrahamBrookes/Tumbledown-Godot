extends Node

## The Slashable component allows objects to be slashed. When we receive a slash
## we emit a signal for the context to react.
class_name Slashable

signal slashed(damage: Damage)

# when we are slashed, emit the signal
func receive_slash(damage: Damage):
	emit_signal("slashed", damage)
