extends State
class_name Slash

var can_slash_again: bool

# an array of enemies entering and exiting our hit radius
var hittable_enemies : Array = []

func Enter(extra_data = null):
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


func _on_hit_capsule_body_entered(body):
	if body.has_method('hurt'):
		print("body has hurt: ", body)
		hittable_enemies.append(body)


func _on_hit_capsule_body_exited(body):
	if body.has_method('hurt'):
		hittable_enemies.erase(body)


func _on_apply_hurt_timer_timeout():
	# loop through enemeies and hurt them
	for enemy in hittable_enemies:
		enemy.hurt(1, owner.global_position)
