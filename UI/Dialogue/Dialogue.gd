extends Control
class_name Dialogue

# the text we will display - this is passed in from another script
var textContent

# our timer - each time the timer expires we reveal another character
var timer

# the text node in the scene tree used for showing text content
var textNode : RichTextLabel

# the body we are conversing with
var conversee : Conversee


# Called when the node enters the scene tree for the first time.
func _ready():
	timer = $Timer
	
	textNode = $ColorRect/Text
	textNode.visible_characters = 0
	
	visible = false

# a public method for passing te content in to this node
func setText(text: String):
	textNode.text = text
	textNode.visible_characters = 0

# a public method for starting the text roll by kicking off the timer
func startText():
	visible = true
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("interact"):
		if !!conversee:
			conversee.start_conversation(self)
	pass


func _on_timer_timeout():
	textNode.visible_characters += 1

# When a body enters the attack range collider, tell it we want to converse
func _on_conversation_collider_entered(body):
	if body is Conversee:
		if !conversee:
			conversee = body
			conversee.show_conversation_start()

# When a body enters the attack range collider, tell it we want to converse
func _on_conversation_collider_exited(body):
	if body == conversee:
		body.hide_conversation_start()
		conversee = null
