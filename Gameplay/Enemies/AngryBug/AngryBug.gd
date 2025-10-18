extends CharacterBody3D
class_name AngryBug

@export var INVINCIBLE : bool = false
@export var TRAVEL_SPEED = 2.0
@export var TURN_SPEED := 5.0
@export var ATTACK_RANGE := 1.5
@export var ATTACK_COOLDOWN := 0.5

# the behaviour tree is for querying data and making decisions
@onready var behaviourTree: BehaviourTree = $BehaviourTree

# the state machine is for handling movement and animation states
@onready var stateMachine: StateMachine = $StateMachine

# the behaviour tree makes decisions and signals the state machine to change states.
# we can gate transitions in the state machine by using the 'IsInStates' condition.

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize blackboard with shared data
	behaviourTree.set_blackboard_value("owner", self)
	behaviourTree.set_blackboard_value("target", null)
	behaviourTree.set_blackboard_value("attack_range", ATTACK_RANGE)

	
func _physics_process(delta):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# called when we receive a hurt from somewhere
func receive_damage(damage:Damage):
	# only if we're not invincible
	if INVINCIBLE:
		return
	else:
		INVINCIBLE = true
	
	# get the vector from the source to us
	var attackVector = (
		global_transform.origin - damage.source.global_transform.origin
	)
	attackVector.y = 0
	attackVector = attackVector.normalized()
	
	# since our states handle move_and_slide and manage velocity themselves
	# we need to _use_ a state to apply pushback using velocity
	$StateMachine.travel("AngryBugWasAttacked", {
		"pushback": attackVector * 20,
		"target": damage.source
	})
	
	# flash visibility
	for n in 12:
		visible = !visible
		await get_tree().create_timer(0.05).timeout
	
	INVINCIBLE = false

func on_DetectionArea_body_entered(body):
	# when the player enters the detection volume, update the blackboard so we can make decisions
	if body.has_property("team") && body.team == 1 && behaviourTree.get_blackboard_value("target") == null:
		behaviourTree.set_blackboard_value("target", body)
		
func on_DetectionArea_body_exited(body):
	# when the player leaves the detection volume, lose sight of the player
	if body == behaviourTree.get_blackboard_value("target"):
		behaviourTree.set_blackboard_value("target", null)
