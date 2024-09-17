extends InteractableGUI
class_name Keybind

@export var action_name : String

func _ready():
	super._ready()
	no_sfx = true
	toggle_mode = true
	
	connect("toggled", _toggled)
	
	set_button_text()

func set_button_text():
	var action_event = InputMap.action_get_events(action_name)[0]
	if action_event:
		text = "%s" % InputMap.action_get_events(action_name)[0].as_text()
	else:
		text = "!"

func _toggled(_toggled_on):
	if button_pressed:
		text = "*"
		release_focus()
	else:
		set_button_text()
		grab_focus()

func _unhandled_input(event):
	if button_pressed:
		if event.pressed:
			if event.is_action_pressed("pause"):
				button_pressed = false
			elif event is InputEventKey:
				OptionsHandler.set_controls(action_name, event.keycode)
				button_pressed = false
				set_button_text()
			else:
				button_pressed = false
