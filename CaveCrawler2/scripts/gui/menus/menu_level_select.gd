extends Control

@export var options_scene : PackedScene

func _on_options_pressed():
	var o = options_scene.instantiate()
	get_tree().get_root().add_child(o)

func _on_back_pressed():
	call_deferred("queue_free")
