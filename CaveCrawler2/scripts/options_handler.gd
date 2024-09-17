extends Node

signal bloom_changed
signal cursor_changed
signal volume_sfx_changed
signal volume_music_changed

var fullscreen_enabled := false
var cursor_visible := true
var particles_enabled := true
var bloom_intensity := 0.5
var volume_sfx := 5.0
var volume_music := 5.0

@export var look_up : InputEvent
@export var drop_through : InputEvent
@export var left : InputEvent
@export var right : InputEvent
@export var jump : InputEvent
@export var shoot : InputEvent

var levels_unlocked := 1

var data = {}
var controls = {}

func _ready():
	load_options()
	load_controls()
	
	set_fullscreen(fullscreen_enabled)
	set_cursor(cursor_visible)
	set_particles(particles_enabled)
	set_bloom(bloom_intensity)
	set_volume_sfx(volume_sfx)
	set_volume_music(volume_music)
	
	#print(controls)
	
	set_levels_unlocked(levels_unlocked)

func save_options():
	var file = FileAccess.open(Global.save_path, FileAccess.WRITE)
	
	data = {
		"fullscreen_enabled": fullscreen_enabled,
		"cursor_visible": cursor_visible,
		"particles_enabled": particles_enabled,
		"bloom_intensity": bloom_intensity,
		"volume_sfx": volume_sfx,
		"volume_music": volume_music,
		"levels_unlocked": levels_unlocked,
	}
	
	file.store_var(data)
	
func save_controls():
	var file = FileAccess.open(Global.controls_path, FileAccess.WRITE)
	
	#print(controls)
	
	file.store_var(controls)

func load_options():
	if FileAccess.file_exists(Global.save_path):
		var file = FileAccess.open(Global.save_path, FileAccess.READ)
		var load_data = file.get_var()
		
		#print(load_data)
		
		fullscreen_enabled = load_data.fullscreen_enabled
		cursor_visible = load_data.cursor_visible
		particles_enabled = load_data.particles_enabled
		bloom_intensity = load_data.bloom_intensity
		volume_sfx = load_data.volume_sfx
		
		if load_data.has("volume_music") and load_data.volume_music != null:
			volume_music = load_data.volume_music
		else:
			set_volume_music(volume_music)
		
		if load_data.has("levels_unlocked") and load_data.levels_unlocked != null:
			levels_unlocked = load_data.levels_unlocked
		else:
			set_levels_unlocked(levels_unlocked)
		

func load_controls():
	if FileAccess.file_exists(Global.controls_path):
		var file = FileAccess.open(Global.controls_path, FileAccess.READ)
		var load_controls = file.get_var()
		
		#print(load_controls["look_up"])
		set_controls("look_up", load_controls["look_up"])
		set_controls("drop_through", load_controls["drop_through"])
		set_controls("left", load_controls["left"])
		set_controls("right", load_controls["right"])
		set_controls("jump", load_controls["jump"])
		set_controls("shoot", load_controls["shoot"])
	else:
		set_controls("look_up", look_up.keycode)
		set_controls("drop_through", drop_through.keycode)
		set_controls("left", left.keycode)
		set_controls("right", right.keycode)
		set_controls("jump", jump.keycode)
		set_controls("shoot", shoot.keycode)

func set_fullscreen(setting : bool):
	fullscreen_enabled = setting
	
	if setting == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	save_options()

func set_cursor(setting : bool):
	cursor_visible = setting
	emit_signal("cursor_changed")
	
	if setting == true:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		if get_viewport().gui_get_focus_owner() != null:
			get_viewport().gui_get_focus_owner().release_focus()
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	save_options()

func set_particles(setting : bool):
	particles_enabled = setting
	save_options()

func set_bloom(setting):
	bloom_intensity = setting
	save_options()
	emit_signal("bloom_changed")

func set_volume_sfx(setting):
	#print("S ", setting)
	volume_sfx = setting
	save_options()
	emit_signal("volume_sfx_changed")

func set_volume_music(setting):
	#print("S ", setting)
	volume_music = setting
	save_options()
	emit_signal("volume_music_changed")

func set_levels_unlocked(levels):
	if levels_unlocked < levels:
		levels_unlocked = levels
		
		if levels_unlocked == 6:
			SteamHandler.set_achievement("ach_beat_w1")
		
		if levels_unlocked == 11:
			SteamHandler.set_achievement("ach_beat_w2")
		
		if levels_unlocked == 16:
			SteamHandler.set_achievement("ach_beat_w3")
		
		save_options()

func set_controls(action_name : String, action_event_keycode):
	controls[action_name] = action_event_keycode
	
	InputMap.action_erase_events(action_name)
	
	var temp = InputEventKey.new()
	temp.keycode = action_event_keycode
	InputMap.action_add_event(action_name, temp)
	
	save_controls()
