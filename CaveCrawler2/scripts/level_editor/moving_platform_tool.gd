extends Node2D
class_name MovingPlatformTool

var size : Vector2
var remove_from_array : bool
var button_being_pressed_down := false

func _input(event):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if button_being_pressed_down:
			global_position = get_global_mouse_position().snapped(Vector2(8, 8))
