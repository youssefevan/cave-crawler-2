extends Control

var level1 = preload("res://scenes/world.tscn")

func _on_options_pressed():
	var o = Global.options_scene.instantiate()
	get_tree().get_root().add_child(o)

func _on_back_pressed():
	call_deferred("queue_free")

func _on_world_1_btn_pressed():
	var level = level1.instantiate()
	get_tree().get_root().add_child(level)
