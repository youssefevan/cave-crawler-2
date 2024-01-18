extends Control

@export var slider_sfx : VSlider
@export var slider_music : VSlider

@export var btn_fullscreen : Button
@export var btn_cursor : Button
@export var btn_particles : Button
@export var slider_bloom : HSlider

@export var btn_back : Button

func _ready():
	if OptionsHandler.cursor_visible == false:
		slider_sfx.grab_focus()
	
	sync_options()

func _on_back_pressed():
	exit()
	Global.exiting_sub_menu()
	call_deferred("queue_free")

func _on_toggle_fullscreen_toggled(toggled_on):
	OptionsHandler.set_fullscreen(toggled_on)
	OptionsHandler.save_options()

func _on_toggle_cursor_toggled(toggled_on):
	OptionsHandler.set_cursor(toggled_on)
	OptionsHandler.save_options()

func _on_toggle_particles_toggled(toggled_on):
	OptionsHandler.set_particles(toggled_on)
	OptionsHandler.save_options()

func _on_bloom_intensity_value_changed(value):
	OptionsHandler.set_bloom(value/slider_bloom.max_value)
	OptionsHandler.save_options()

func _on_volume_sounds_value_changed(value):
	OptionsHandler.set_volume_sfx(value)
	OptionsHandler.save_options()

func sync_options():
	btn_fullscreen.button_pressed = OptionsHandler.fullscreen_enabled
	btn_cursor.button_pressed = OptionsHandler.cursor_visible
	btn_particles.button_pressed = OptionsHandler.particles_enabled
	slider_bloom.value = (OptionsHandler.bloom_intensity*slider_bloom.max_value)
	slider_sfx.value = OptionsHandler.volume_sfx
	#print("?: ", slider_sfx.value)

func exit():
	OptionsHandler.save_options()
	Global.exiting_sub_menu()
	call_deferred("queue_free")

func _input(event):
	if event is InputEvent:
		if Input.is_action_just_pressed("ui_cancel"):
			btn_back.grab_focus()
