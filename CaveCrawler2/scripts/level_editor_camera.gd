extends Camera2D

var zoom_sensitivity := 0.1
var zoom_min := 0.5
var zoom_max := 2.0
var pan_sensitivity := 1.0

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
		position -= event.relative * pan_sensitivity / zoom
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom += Vector2(zoom_sensitivity, zoom_sensitivity)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom -= Vector2(zoom_sensitivity, zoom_sensitivity)
	
	zoom.x = clamp(zoom.x, zoom_min, zoom_max)
	zoom.y = clamp(zoom.y, zoom_min, zoom_max)
