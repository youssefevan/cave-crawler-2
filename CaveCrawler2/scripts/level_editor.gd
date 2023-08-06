extends Node2D

@onready var tiles = $TileMap
var tile_size = 8

var tileset_coordinates : Vector2

func _ready():
	tileset_coordinates = Vector2.ZERO

func _on_tool_selected(tile_coordinates, tool_type):
	tileset_coordinates = tile_coordinates

func _unhandled_input(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		tiles.set_cell(0, get_global_mouse_position()/tile_size, 3, tileset_coordinates)
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		tiles.erase_cell(0, get_global_mouse_position()/tile_size)
