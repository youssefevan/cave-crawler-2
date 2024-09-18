extends Node

var save_path = "user://save_data.dat"
var controls_path = "user://controls.dat"
var level_path = "user://custom_levels/"

var main_menu_scene = load("res://scenes/gui/menus/menu_main.tscn")
var options_scene = load("res://scenes/gui/menus/menu_options.tscn")
var level_select_scene = load("res://scenes/gui/menus/menu_level_select.tscn")
var level_editor_scene = load("res://scenes/level_editor/level_editor.tscn")
var custom_level_loader_scene = load("res://scenes/level_editor/custom_level_loader.tscn")
var custom_level_interface_scene = load("res://scenes/gui/menu_custom_levels.tscn")
var pause_scene = load("res://scenes/gui/menus/menu_pause.tscn")
var player_scene = load("res://scenes/player.tscn")

var player_cell_type = Vector2i(0, 4)

var level_to_load : String
var creating_new_level : bool

var custom_level : bool

var checkpoint_passed = false
var checkpoint_position : Vector2

var last_focused_node

var next_level

func _ready():
	var dir = DirAccess.open("user://")
	if dir.dir_exists(Global.level_path) == false:
		dir.make_dir("custom_levels")

func entering_sub_menu():
	last_focused_node = get_viewport().gui_get_focus_owner()

func exiting_sub_menu():
	#if OptionsHandler.cursor_visible == false:
	if last_focused_node != null:
		last_focused_node.grab_focus()
