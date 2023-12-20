extends Control

func _ready():
	visible = false

func _on_options_pressed():
	var o = Global.options_scene.instantiate()
	get_parent().add_child(o)

func _on_main_menu_pressed():
	visible = false
	get_tree().paused = false
	get_tree().change_scene_to_packed(Global.main_menu_scene)

func _on_retry_pressed():
	visible = false
	get_tree().paused = false
	get_tree().reload_current_scene()
