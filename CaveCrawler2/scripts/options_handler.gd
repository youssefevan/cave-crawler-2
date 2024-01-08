extends Node

var fullscreen_enabled : bool
var cursor_visible := true
var particles_enabled := true
var bloom_intensity

func _ready():
	load_options()
	if fullscreen_enabled == true:
		enable_fullscreen()
	else:
		disable_fullscreen()
	
	if cursor_visible == true:
		show_cursor()
	else:
		hide_cursor()
	
	if particles_enabled == true:
		enable_particles()
	else:
		disable_particles()

func save_options():
	var file = FileAccess.open(Global.save_path, FileAccess.WRITE)
	file.store_var(fullscreen_enabled)
	file.store_var(cursor_visible)
	file.store_var(particles_enabled)

func load_options():
	if FileAccess.file_exists(Global.save_path):
		var file = FileAccess.open(Global.save_path, FileAccess.READ)
		fullscreen_enabled = file.get_var(fullscreen_enabled)
		cursor_visible = file.get_var(cursor_visible)
		particles_enabled = file.get_var(particles_enabled)

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
