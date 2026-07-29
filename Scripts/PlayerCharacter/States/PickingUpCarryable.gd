extends State

## This state is for the short time where the player is picking up a carryable.
## Since we need to pick the object up, we have a function call from a keyframe
## within the AnimationStateMachine's PickingUpCarryable animation
class_name PickingUpCarryable

## The Carryable we are picking up
var target_carryable: BasicCarryable

## The bone onto which we shall attach the Carryable
@export var path_follow: PathFollow3D

## because logical keyframes dever damn work I'm just going to use a timer
@export var start_until_attach_time: Timer

## We're going to us ea curve to have direct control over the path of the Carryable
@export var pickup_curve: Curve3D

## how long it should take for the item to travel the path
@export var lift_duration: float = 1.0

## this state will override the interactors interactable to force throwing as a
## workaround to having an actual carrying object state - we're reusing Locomote
@export var interactor: Interactor

## We enter this state with a reference to the target Carryable
func Enter(extra_data = null):
	target_carryable = extra_data as BasicCarryable
	start_until_attach_time.start()

## on exit we want to flick the interactor override so we show the throw option
func Exit():
	interactor.override_interactable(target_carryable.throw_interactable)

func _on_start_until_attach_time_timeout():
	attach_carryable()

## called on keyframe, attach the Carryable
func attach_carryable():
	# disable physics on the carryable for the sake of simplicity
	target_carryable.disable_physics()
	
	# reset the path follower so we animate from the bottom
	path_follow.progress_ratio = 0.0
	
	# reset local transform and reparent
	target_carryable.transform = Transform3D.IDENTITY
	target_carryable.reparent(path_follow)
	
	# tween to slide the object along the 3D path handles
	var tween = create_tween()
	tween.tween_method(
		animate_step,
		0.0, # From
		1.0,       # To
		lift_duration        # Duration
	)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	tween.tween_callback(func():
		animate_step(1.0)
	
		# just use Locomote
		state_machine.TransitionTo("Locomote")
	)
	
func animate_step(progress: float):
	state_machine.animTree.set("parameters/CarryingTorsoArms/blend_amount", progress)
	path_follow.progress_ratio = progress
	target_carryable.transform = Transform3D.IDENTITY
