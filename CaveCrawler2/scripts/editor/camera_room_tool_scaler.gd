extends Button

var active = false
var dif = Vector2(0, 0)

func _process(delta):
	var mouse_position = get_viewport().get_mouse_position()
	if active:	
		global_position = mouse_position + dif

func _on_button_down():
	dif = get_global_position() - get_viewport().get_mouse_position()
	active = true

func _on_button_up():
	active = false
