extends Control

@onready var title_music = preload("res://audio/music/title.ogg")

func _ready():
	AudioHandler.play_music(title_music, false)
	
	Global.checkpoint_passed = false
	
	#if OptionsHandler.cursor_visible == false:
	$Buttons/Play.grab_focus()
	
	#print(OptionsHandler.levels_unlocked)

func _on_play_pressed():
	Global.custom_level = false
	get_tree().change_scene_to_packed(Global.level_select_scene)

func _on_editor_pressed():
	Global.custom_level = true
	get_tree().change_scene_to_packed(Global.custom_level_interface_scene)

func _on_quit_pressed():
	get_tree().quit()

func _on_options_pressed():
	Global.entering_sub_menu()
	var o = Global.options_scene.instantiate()
	get_tree().get_root().add_child(o)
	o.btn_fullscreen.grab_focus()


func _on_logo_pressed():
	if $Title.frame < 2:
		$Title.frame += 1
	else:
		$Title.frame = 0
