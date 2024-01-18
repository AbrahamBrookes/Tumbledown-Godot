extends State
# when the player walks up to a pushable object they will lean into it for a
# short time before actually pushing it
class_name LeaningCrate

var crate # the crate we are pushing
var pushingTimer = 0.0 # how long the player has been pushing into the crate
var pushTime = 0.5 # how long until the push begins
var push_dir = Vector2.ZERO # cache the push dir so we can check if it changed

func Enter(extra_data = null):
	assert(!!extra_data, "we need to be passed a crate to push!")
	crate = extra_data
	# cache the push_dir
	push_dir = Input.get_vector("walk_west", "walk_east", "walk_north", "walk_south").round()
	stateMachine.travel("leaning_pushable")

func Physics_Update(_delta: float):
	# Get the input direction to see if the player is pushing into the crate
	var input_dir = Input.get_vector("walk_west", "walk_east", "walk_north", "walk_south").round()
	print('input:', input_dir, 'push:', push_dir)
	# If the player pushes into the crate for one second, transition to PushingCrate
	if input_dir == push_dir:
		# increment the timer
		pushingTimer += _delta
		if pushingTimer > pushTime:
			var pushy_crate = crate as pushy_crate
			pushy_crate.push(push_dir)
			get_parent().TransitionTo('PushingCrate', crate)
				
	else:
		# reset the timer
		pushingTimer = 0.0
		get_parent().TransitionTo('Locomote')
