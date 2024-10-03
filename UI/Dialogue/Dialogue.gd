extends Control
class_name Dialogue

# the text we will display - this is passed in from another script
var textContent

# our timer - each time the timer expires we reveal another character
var timer

# the text node in the scene tree used for showing text content
var textNode : RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	timer = $Timer
	
	textNode = $ColorRect/Text
	textNode.visible_characters = 0
	
	setText("this is my test text")
	startText()

# a public method for passing te content in to this node
func setText(text: String):
	textContent = text
	textNode.visible_characters = 0

# a public method for starting the text roll by kicking off the timer
func startText():
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	textNode.visible_characters += 1
