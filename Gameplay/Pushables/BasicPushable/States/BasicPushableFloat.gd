extends State

class_name BasicPushableFloat

## This state is for a rolling log that has just fallen in the water and is floating. When we first
## hit the water we want to plunge in, then resurface and bob. So in enter we set up an initial big,
## deep but declining sinewave to use to offset our Y position, and we set up a smaller sine wave to
## bob in the water idle. We also oscillate slightly to give the appearance of turbulence

## During physics update, handle bobbing
func Physics_Update(_delta: float):
	var bobbing_offset = sin(Time.get_ticks_msec() / 500.0) * 0.0007
	var turbulence_offset = Vector3(
		sin(Time.get_ticks_msec() / 700.0) * 0.0002,
		bobbing_offset,
		sin(Time.get_ticks_msec() / 900.0) * 0.0002
	)
	owner.global_position += turbulence_offset
