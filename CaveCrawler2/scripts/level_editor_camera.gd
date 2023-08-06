extends Camera2D

var zoom_sensitivity := 0.05
var zoom_min := 1.5
var zoom_max := 0.3
var pan_sensitivity := 1.0

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
		global_position -= event.relative * pan_sensitivity / zoom
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom += Vector2(zoom_sensitivity, zoom_sensitivity)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom -= Vector2(zoom_sensitivity, zoom_sensitivity)
	
	zoom.x = clamp(zoom.x, zoom_max, zoom_min)
	zoom.y = clamp(zoom.y, zoom_max, zoom_min)
