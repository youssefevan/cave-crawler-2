extends Node

var fullscreen_enabled : bool
var cursor_visible := true
var particles_enabled := true
var bloom_intensity

func save_options():
	pass

func load_options():
	pass


func enable_fullscreen():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	fullscreen_enabled = true

func disable_fullscreen():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	fullscreen_enabled = false


func show_cursor():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if get_viewport().gui_get_focus_owner() != null:
		get_viewport().gui_get_focus_owner().release_focus()
	cursor_visible = true

func hide_cursor():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	cursor_visible = false


func enable_particles():
	particles_enabled = true

func disable_particles():
	particles_enabled = false
