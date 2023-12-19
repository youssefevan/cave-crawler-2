extends Control

var paused = false

func _ready():
	visible = false

func _input(event):
	if Input.is_action_just_pressed("pause"):
		if paused == false:
			pause()
		else:
			unpause()

func pause():
	paused = true
	visible = true
	get_tree().paused = true

func unpause():
	paused = false
	visible = false
	get_tree().paused = false

func _on_continue_pressed():
	unpause()

func _on_options_pressed():
	var o = Global.options_scene.instantiate()
	get_parent().add_child(o)

func _on_main_menu_pressed():
	unpause()
	get_tree().change_scene_to_packed(Global.main_menu_scene)
