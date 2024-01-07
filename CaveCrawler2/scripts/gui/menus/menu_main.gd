extends Control

func _ready():
	Global.checkpoint_passed = false

func _on_play_pressed():
	Global.custom_level = false
	get_tree().change_scene_to_packed(Global.level_select_scene)

func _on_editor_pressed():
	Global.custom_level = true
	get_tree().change_scene_to_packed(Global.custom_level_interface_scene)

func _on_quit_pressed():
	get_tree().quit()

func _on_options_pressed():
	var o = Global.options_scene.instantiate()
	get_tree().get_root().add_child(o)
