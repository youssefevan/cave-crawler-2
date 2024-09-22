extends Control

var paused = false
var window

var player

var sfx_pause = preload("res://audio/sfx/menu/button_forward.ogg")
var sfx_unpause = preload("res://audio/sfx/menu/button_back.ogg")
var music_pause = preload("res://audio/music/pause.ogg")

var focus_button

var previous_window_position

func _ready() -> void:
	player = get_parent().get_parent()
	
	if Global.custom_level == false:
		$Buttons/Edit.visible = false
	else:
		$Buttons/Edit.visible = true
	visible = false
	
	window = get_window()
	previous_window_position = window.position

func _input(_event):
	if player.health > 0 and player.level_end == false:
		if Input.is_action_just_pressed("pause"):
			if paused == false:
				pause()
			else:
				unpause()

func _process(_delta):
	if !window.has_focus() and !paused:
		if get_parent().get_parent().level_end == false and get_parent().get_parent().health > 0:
			pause()
	
	if window.position != previous_window_position and !paused:
		if get_parent().get_parent().level_end == false and get_parent().get_parent().health > 0:
			pause()
	
	previous_window_position = window.position

func pause():
	AudioHandler.play_sfx(sfx_pause)
	AudioHandler.play_music(music_pause, true)
	
	paused = true
	visible = true
	
	#if OptionsHandler.cursor_visible == false:
	$Buttons/Continue.grab_focus()
	
	get_tree().paused = true

func unpause():
	AudioHandler.play_sfx(sfx_unpause)
	AudioHandler.resume_music()
	
	paused = false
	visible = false
	get_tree().paused = false

func _on_continue_pressed():
	unpause()

func _on_options_pressed():
	Global.entering_sub_menu()
	var o = Global.options_scene.instantiate()
	get_parent().add_child(o)
	o.btn_fullscreen.grab_focus()

func _on_main_menu_pressed():
	unpause()
	get_tree().change_scene_to_packed(Global.main_menu_scene)

func _on_restart_pressed():
	Global.checkpoint_passed = false
	unpause()
	get_tree().reload_current_scene()

func _on_edit_pressed():
	unpause()
	Global.creating_new_level = false
	get_tree().change_scene_to_packed(Global.level_editor_scene)
