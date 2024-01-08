extends Control

@export var slider_sfx : VSlider
@export var sldier_music : VSlider

@export var btn_fullscreen : Button
@export var btn_cursor : Button
@export var btn_bloom : Button
@export var btn_particles : Button

@export var btn_back : Button

func _ready():
	if OptionsHandler.cursor_visible == false:
		slider_sfx.grab_focus()
	
	load_options()

func _on_back_pressed():
	exit()
	Global.exiting_sub_menu()
	call_deferred("queue_free")

func _on_toggle_fullscreen_toggled(toggled_on):
	if toggled_on == true:
		OptionsHandler.enable_fullscreen()
	else:
		OptionsHandler.disable_fullscreen()

func _on_toggle_cursor_toggled(toggled_on):
	if toggled_on == true:
		OptionsHandler.show_cursor()
	else:
		OptionsHandler.hide_cursor()

func load_options():
	btn_fullscreen.button_pressed = OptionsHandler.fullscreen_enabled
	btn_cursor.button_pressed = OptionsHandler.cursor_visible

func exit():
	Global.exiting_sub_menu()
	call_deferred("queue_free")

func _input(event):
	if event is InputEvent:
		if Input.is_action_just_pressed("ui_cancel"):
			btn_back.grab_focus()
