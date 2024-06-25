extends InteractableGUI

@export var level : PackedScene

signal level_selected(level)

func _ready():
	connect("pressed", _on_pressed)

func _on_pressed():
	emit_signal("level_selected", level)
