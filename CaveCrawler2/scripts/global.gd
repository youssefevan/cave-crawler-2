extends Node

var main_menu_scene = preload("res://scenes/gui/menus/menu_main.tscn")
var options_scene = preload("res://scenes/gui/menus/menu_options.tscn")
var level_select_scene = preload("res://scenes/gui/menus/menu_level_select.tscn")
var level_editor_scene = preload("res://scenes/level_editor.tscn")
var custom_level_loader_scene = preload("res://scenes/custom_level_loader.tscn")
var custom_level_interface_scene = preload("res://scenes/gui/custom_level_interface.tscn")
var pause_scene = preload("res://scenes/gui/menus/menu_pause.tscn")
var player_scene = load("res://scenes/player.tscn")

var player_cell_type = Vector2i(0, 4)

var level_to_load : String
var creating_new_level : bool

var custom_level : bool

var checkpoint_passed = false
var checkpoint_position : Vector2
