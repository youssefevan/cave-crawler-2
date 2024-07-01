extends Control

var paused = false

var player

var sfx_pause = preload("res://audio/sfx/menu/pause.ogg")
var sfx_unpause = preload("res://audio/sfx/menu/unpause.ogg")

func _ready() -> void:
	player = get_parent().get_parent()
	
	if Global.custom_level == false:
		$Buttons/Edit.visible = false
	else:
		$Buttons/Edit.visible = true
	visible = false

func _input(event):
	if player.health > 0 and player.level_end == false:
		if Input.is_action_just_pressed("pause"):
			if paused == false:
				pause()
			else:
				unpause()

func pause():
	AudioHandler.play_sfx(sfx_pause)
	paused = true
	visible = true
	
	if OptionsHandler.cursor_visible == false:
		$Buttons/Continue.grab_focus()
	
	get_tree().paused = true

func unpause():
	AudioHandler.play_sfx(sfx_unpause)
	paused = false
	visible = false
	get_tree().paused = false

func _on_continue_pressed():
	unpause()

func _on_options_pressed():
	Global.entering_sub_menu()
	var o = Global.options_scene.instantiate()
	get_parent().add_child(o)

func _on_main_menu_pressed():
	unpause()
	get_tree().change_scene_to_packed(Global.main_menu_scene)

func _on_restart_pressed():
	Global.checkpoint_passed = false
	unpause()
	get_tree().reload_current_scene()

func _on_edit_pressed():
	unpause()
	get_tree().change_scene_to_packed(Global.level_editor_scene)
