extends State
# when the player walks up to a pushable object they will lean into it for a
# short time before actually pushing it
class_name LeaningCrate

var crate # the crate we are pushing
var pushingTimer = 0.0 # how long the player has been pushing into the crate
var pushTime = 0.5 # how long until the push begins
var push_dir = Vector2.ZERO # cache the push dir so we can check if it changed

func Enter(extra_data = null):
	pass
#	assert(!!extra_data, "we need to be passed a crate to push!")
#	crate = extra_data
#	
#	# when we enter this state, cache the input as push_dir
#	push_dir = Input.get_vector("walk_west", "walk_east", "walk_north", "walk_south").round()
#	
#	# reset the push timer
#	pushingTimer = 0.0
#	
#	stateMachine.travel("leaning_pushable")

func Physics_Update(_delta: float):
	pass
#	# prevent movement
#	playerCharacter.velocity = Vector3.ZERO
#
#	# don't allow diagonal pushing
#	if push_dir not in [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]:
#		get_parent().TransitionTo('Locomote')
#		return
#	
#	# Get the input direction to see if the player is pushing into the crate
#	var input_dir = Input.get_vector("walk_west", "walk_east", "walk_north", "walk_south").round()
#	
#	# if the player has changed direction, transition back to locomote
#	if input_dir != push_dir:
#		get_parent().TransitionTo('Locomote')
#		return
#
#	# we don't want to allow the player to move the crate laterally, so make sure the crate
#	# is always directly where the player is pushing
#	var push_vector = Vector3(push_dir.x, crate.global_position.round().y, push_dir.y)
#	var push_destination = playerCharacter.global_position.round() + push_vector
#	print("push_vector", push_vector)
#	print("push_destination", push_destination)
#	print("crate", crate.global_position.round())
#	if push_destination != crate.global_position.round():
#		get_parent().TransitionTo('Locomote')
#		return
#	
#	# If the player pushes into the crate for pushTime, transition to PushingCrate
#	if input_dir != Vector2.ZERO:
#		# increment the timer
#		pushingTimer += _delta
#		if pushingTimer > pushTime:
#			var pushy_crate = crate as pushy_crate
#			pushy_crate.push(push_dir)
#			get_parent().TransitionTo('PushingCrate', crate)
#			pushingTimer = 0.0
#				
#	else:
#		# reset the timer
#		pushingTimer = 0.0
#		get_parent().TransitionTo('Locomote')
#
