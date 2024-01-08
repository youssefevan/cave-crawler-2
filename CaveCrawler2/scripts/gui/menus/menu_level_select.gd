extends Control

var level1 = preload("res://scenes/world.tscn")

func _ready():
	$Worlds/World1/World1Btn.grab_focus()
	
	Global.checkpoint_passed = false

func _on_options_pressed():
	var o = Global.options_scene.instantiate()
	get_tree().get_root().add_child(o)

func _on_back_pressed():
	get_tree().change_scene_to_packed(Global.main_menu_scene)

func _on_world_1_btn_pressed():
	get_tree().change_scene_to_packed(level1)
