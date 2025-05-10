extends State
class_name AngryBugLocomote

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var mass = 10.0

@export var SPEED = 5.0
@export var LERP_SPEED = 0.35

var can_attack = true

func Enter(extra_data = null):
	machine.animTree.set("parameters/AnimSpeed/scale", 0.5)
	# to set anim speed
	var speed = 1
	machine.animTree.set("parameters/StateMachine/AngryBugLocomote/blend_position", speed)

func Exit():
	pass


func Update(_delta: float):
	pass


func Physics_Update(_delta: float):
	pass
