extends State

class_name BasicPushableIdle

# Get the gravity from the project settings once
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

## During physics update, just do gravity
func Physics_Update(_delta: float):
	owner.velocity.x = 0
	owner.velocity.y -= gravity
	owner.velocity.z = 0
	owner.move_and_slide()

func be_pushed():
	state_machine.TransitionTo("BeingPushed", InputUtils.get_cardinal_input())
