extends CharacterBody3D

class_name BasicPushable

## The BasicPushable is something like a crate or similar that can
## be pushed around by the player. It moves a certain distance each
## time it is pushed and stops either when it hits an obstacle or
## when it has moved the maximum distance.

# how far the pushable can be pushed in one go
@export var push_distance: float = 2.0

# how fast the pushable moves when being pushed
@export var push_speed: float = 4.0

# a reference to the StateMachine that handles movement logic
@export var state_machine: StateMachine = null
