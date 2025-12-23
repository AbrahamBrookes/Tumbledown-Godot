extends StaticBody3D
class_name Conversee

@onready var talkSprite : MeshInstance3D = $TalkUI

# the initial line
@export var firstLine : ConversationLine

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	hide_conversation_start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func show_conversation_start():
	talkSprite.visible = true

func hide_conversation_start():
	talkSprite.visible = false
	
func start_conversation(dialogue : Dialogue):
	dialogue.setText(firstLine.text)
	dialogue.startText()
