extends Node

signal bloom_changed
signal cursor_changed
signal volume_sfx_changed

var fullscreen_enabled : bool
var cursor_visible := true
var particles_enabled := true
var bloom_intensity := 0.5
var volume_sfx := 5.0

func _ready():
	load_options()
	set_fullscreen(fullscreen_enabled)
	set_cursor(cursor_visible)
	set_particles(particles_enabled)
	set_bloom(bloom_intensity)
	set_volume_sfx(volume_sfx)

func save_options():
	var file = FileAccess.open(Global.save_path, FileAccess.WRITE)
	file.store_var(fullscreen_enabled)
	file.store_var(cursor_visible)
	file.store_var(particles_enabled)
	file.store_var(bloom_intensity)
	file.store_var(volume_sfx)

func load_options():
	if FileAccess.file_exists(Global.save_path):
		var file = FileAccess.open(Global.save_path, FileAccess.READ)
		fullscreen_enabled = file.get_var(fullscreen_enabled)
		cursor_visible = file.get_var(cursor_visible)
		particles_enabled = file.get_var(particles_enabled)
		bloom_intensity = file.get_var(bloom_intensity)
		volume_sfx = file.get_var(volume_sfx)

func set_fullscreen(setting : bool):
	fullscreen_enabled = setting
	
	if setting == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func set_cursor(setting : bool):
	cursor_visible = setting
	emit_signal("cursor_changed")
	
	if setting == true:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		if get_viewport().gui_get_focus_owner() != null:
			get_viewport().gui_get_focus_owner().release_focus()
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func set_particles(setting : bool):
	particles_enabled = setting

func set_bloom(setting):
	bloom_intensity = setting
	emit_signal("bloom_changed")

func set_volume_sfx(setting):
	#print("S ", setting)
	volume_sfx = setting
	emit_signal("volume_sfx_changed")
