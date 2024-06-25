extends Button
class_name InteractableGUI

func _ready():
	OptionsHandler.connect("cursor_changed", change_mouse_filter)
	change_mouse_filter()

func change_mouse_filter():
	if OptionsHandler.cursor_visible == true:
		mouse_filter = Control.MOUSE_FILTER_STOP # process mouse input
	else:
		mouse_filter = Control.MOUSE_FILTER_IGNORE # ignore mouse input
