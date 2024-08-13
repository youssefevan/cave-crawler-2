extends Button
class_name InteractableGUI

var sfx_next = preload("res://audio/sfx/menu/button_forward.ogg")
var sfx_back = preload("res://audio/sfx/menu/button_back.ogg")

@export var back_button := false
@export var no_sfx := false

func _ready():
	OptionsHandler.connect("cursor_changed", change_mouse_filter)
	connect("pressed", _on_pressed)
	change_mouse_filter()

func change_mouse_filter():
	if OptionsHandler.cursor_visible == true:
		mouse_filter = Control.MOUSE_FILTER_STOP # process mouse input
	else:
		mouse_filter = Control.MOUSE_FILTER_IGNORE # ignore mouse input

func _on_pressed():
	if no_sfx == false:
		if back_button == true:
			AudioHandler.play_sfx(sfx_back)
		else:
			AudioHandler.play_sfx(sfx_next)
