extends Control

func _ready() -> void:
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/gui/menus/menu_main.tscn")
