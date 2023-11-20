extends State
class_name Crouch

func Enter():
	stateMachine.travel("Crouch")


func Exit():
	pass


func Update(_delta: float):
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("walk_west", "walk_east", "walk_north", "walk_south")
	
	# if we are crouching but we have input, go to crawl
	if input_dir.length():
		Transitioned.emit("Crawl")


func Physics_Update(_delta: float):
	pass
