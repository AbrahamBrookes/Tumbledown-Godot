extends State
class_name Slash

var can_slash_again: bool

# an array of slashables able to be slashed
var slashables: Array = []

func Enter(_extra_data = null):
	owner.animTree.set("parameters/AnimSpeed/scale", 3.0)
	can_slash_again = false
	
	# set a timer to limit how fast we can slash
	$SlashAgainTimer.start()
	
	# this timer waits until the start of the animation until the moment we should apply hurt
	$ApplyHurtTimer.start()

func Exit():
	pass

func Update(_delta: float):
	pass
	# hack because I can't get the animation function track to work
	var current_animation = owner.animTree.get("parameters/StateMachine/playback").get_current_node()
	if not current_animation == "Slash":
		Transitioned.emit("Locomote")

func Physics_Update(_delta: float):
	# if the player presses slash while slashing, slash
	if Input.is_action_just_pressed("slash"):
		slash()

func slash():
	if can_slash_again:
		Transitioned.emit("Slash")

# called from an animation call method track
func finish_slashing():
	can_slash_again = true

func _on_slash_detection_area_entered(body):
	var slashable = body.owner.get_node_or_null("Slashable")
	if slashable and slashable is Slashable: 
		slashables.append(slashable)

func _on_slash_detection_area_exited(body):
	var slashable = body.owner.get_node_or_null("Slashable")
	if slashable and slashable is Slashable: 
		slashables.erase(slashable)

# We don't want to slash at the start of the animation or it looks wonky
func _on_apply_hurt_timer_timeout():
	# our damage is a special type with a type and amount
	var damage = Damage.new()
	damage.type = Damage.DamageType.SHARP
	damage.amount = 1
	damage.source = self
	
	# slash any slashables
	for slashable in slashables:
		if slashable is Slashable:
			slashable.receive_slash(damage)
