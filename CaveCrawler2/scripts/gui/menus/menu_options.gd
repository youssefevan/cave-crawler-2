extends Control

@export var slider_sfx : VSlider
@export var slider_music : VSlider

@export var btn_fullscreen : Button
@export var btn_cursor : Button
@export var btn_particles : Button
@export var slider_bloom : HSlider

@export var btn_back : Button

@onready var sfx_next = load("res://audio/sfx/menu_next.ogg")
@onready var sfx_back = load("res://audio/sfx/menu_back.ogg")

func _ready():
	if OptionsHandler.cursor_visible == false:
		slider_sfx.grab_focus()
	
	sync_options()

func _on_back_pressed():
	AudioHandler.play_sfx(sfx_back)
	exit()
	Global.exiting_sub_menu()
	call_deferred("queue_free")

func _on_toggle_fullscreen_toggled(toggled_on):
	AudioHandler.play_sfx(sfx_next)
	OptionsHandler.set_fullscreen(toggled_on)

func _on_toggle_cursor_toggled(toggled_on):
	AudioHandler.play_sfx(sfx_next)
	OptionsHandler.set_cursor(toggled_on)

func _on_toggle_particles_toggled(toggled_on):
	AudioHandler.play_sfx(sfx_next)
	OptionsHandler.set_particles(toggled_on)

func _on_bloom_intensity_value_changed(value):
	AudioHandler.play_sfx(sfx_next)
	var setting = value/2
	OptionsHandler.set_bloom(setting/slider_bloom.max_value)

func _on_volume_sounds_value_changed(value):
	AudioHandler.play_sfx(sfx_next)
	OptionsHandler.set_volume_sfx(value)

func _on_volume_music_value_changed(value):
	AudioHandler.play_sfx(sfx_next)
	OptionsHandler.set_volume_music(value)

func sync_options():
	btn_fullscreen.button_pressed = OptionsHandler.fullscreen_enabled
	btn_cursor.button_pressed = OptionsHandler.cursor_visible
	btn_particles.button_pressed = OptionsHandler.particles_enabled
	slider_bloom.value = (OptionsHandler.bloom_intensity * 2 * slider_bloom.max_value)
	slider_sfx.value = OptionsHandler.volume_sfx
	slider_music.value = OptionsHandler.volume_music
	#print("?: ", slider_sfx.value)

func exit():
	OptionsHandler.save_options()
	Global.exiting_sub_menu()
	call_deferred("queue_free")

func _input(event):
	if event is InputEvent:
		if Input.is_action_just_pressed("ui_cancel"):
			btn_back.grab_focus()
