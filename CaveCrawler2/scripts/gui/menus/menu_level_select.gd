extends Control

@onready var sfx_next = load("res://audio/sfx/menu_next.ogg")
@onready var sfx_back = load("res://audio/sfx/menu_back.ogg")

func _ready():
	if OptionsHandler.cursor_visible == false:
		$"Worlds/World1/ButtonStack/ButtonRow1/1-1".grab_focus()
	
	Global.checkpoint_passed = false

func _on_options_pressed():
	AudioHandler.play_sfx(sfx_next)
	var o = Global.options_scene.instantiate()
	get_tree().get_root().add_child(o)

func _on_back_pressed():
	AudioHandler.play_sfx(sfx_back)
	get_tree().change_scene_to_packed(Global.main_menu_scene)

func _on_level_selected(level):
	AudioHandler.play_sfx(sfx_next)
	get_tree().change_scene_to_packed(level)
