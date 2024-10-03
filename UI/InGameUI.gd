extends Control

# a reference to our Dialogue node so you can easily pass things to it using the autoload global
# InGameUI.Dialogue.setText("this is a test")
# InGameUI.Dialogue.startText()
# InGameUI.Dialogue.set_visible(true)
var Dialogue: Dialogue

# Called when the node enters the scene tree for the first time.
func _ready():
	Dialogue = $Dialogue
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
