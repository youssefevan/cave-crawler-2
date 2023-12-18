extends Control


@export var options_scene : PackedScene

func _on_play_pressed():
	var ls = Global.level_select_scene.instantiate()
	get_tree().get_root().add_child(ls)

func _on_editor_pressed():
	var cli = Global.custom_level_interface_scene.instantiate()
	get_tree().get_root().add_child(cli)

func _on_quit_pressed():
	get_tree().quit()

func _on_options_pressed():
	var o = Global.options_scene.instantiate()
	get_tree().get_root().add_child(o)
