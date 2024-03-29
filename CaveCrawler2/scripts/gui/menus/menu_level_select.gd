extends Control

var level1 = load("res://scenes/levels/world1/level_1_1.tscn")

func _ready():
	if OptionsHandler.cursor_visible == false:
		$Worlds/World1/World1Btn.grab_focus()
	
	Global.checkpoint_passed = false

func _on_options_pressed():
	var o = Global.options_scene.instantiate()
	get_tree().get_root().add_child(o)

func _on_back_pressed():
	get_tree().change_scene_to_packed(Global.main_menu_scene)

func _on_world_1_btn_pressed():
	get_tree().change_scene_to_packed(level1)
