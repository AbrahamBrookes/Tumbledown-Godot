extends State
class_name Slash

var can_slash_again: bool

func Enter(extra_data = null):
	animTree.set("parameters/AnimSpeed/scale", 3.0)
	stateMachine.travel("Slash")
	can_slash_again = false
	
	# set a timer to limit how fast we can slash
	$SlashAgainTimer.start()

func Exit():
	pass


func Update(_delta: float):
	pass
	# hack because I can't get the animation function track to work
	var current_animation = animTree.get("parameters/StateMachine/playback").get_current_node()
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
