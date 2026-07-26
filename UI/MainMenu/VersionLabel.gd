extends Label

func _ready():
	text = "version " + ProjectSettings.get_setting("application/config/version", "0.0.1")
