extends Node2D

@onready var tiles = $TileMap
@onready var name_file_ui = $CanvasLayer/NameFile
@onready var name_file_text = $CanvasLayer/NameFile/TextEdit

var tile_size = 8
var tileset_coordinates : Vector2

var level_name : String
var level_data_file : String

var camera_room_tool_coordinates := Vector2(1, 4)
@export var camera_room_tool_scene : PackedScene

func _ready():
	name_file_ui.visible = false
	tileset_coordinates = Vector2.ZERO

func _on_tool_selected(tile_coordinates, tool_type):
	tileset_coordinates = tile_coordinates

func _unhandled_input(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if tileset_coordinates != camera_room_tool_coordinates:
			tiles.set_cell(0, get_global_mouse_position()/tile_size, 3, tileset_coordinates)
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		tiles.erase_cell(0, get_global_mouse_position()/tile_size)
	
	if Input.is_action_just_pressed("place_tile"):
		if tileset_coordinates == camera_room_tool_coordinates:
			place_camera_room_tool(get_global_mouse_position())

func place_camera_room_tool(coordinates):
	var target_position = coordinates.snapped(Vector2(tile_size, tile_size))
	
	var can_be_placed := true
	for child in get_children():
		if child is CameraRoomTool:
			if child.global_position.x == target_position.x and child.global_position.y == target_position.y:
				can_be_placed = false
	
	if can_be_placed:
		var cr = camera_room_tool_scene.instantiate()
		add_child(cr)
		cr.global_position = target_position

func _on_save_pressed():
	if level_name == null or level_name == "":
		name_file_ui.visible = true
	else:
		save()

func save():
	level_data_file = str("res://", level_name, ".txt")
	var used_cells = tiles.get_used_cells(0)
	var save_file = FileAccess.open(level_data_file, FileAccess.WRITE)
	
	for cell in used_cells.size():
		var cell_coords = used_cells[cell]
		var cell_type = tiles.get_cell_atlas_coords(0, used_cells[cell])
		var cell_data = Vector4(cell_coords.x, cell_coords.y, cell_type.x, cell_type.y)
		save_file.store_line(str(cell_data))
		print(cell_data)
	
	for child in get_children():
		if child is CameraRoomTool:
			var cr_data = Vector4(child.global_position.x, child.global_position.y, child.size.x, child.size.y)
			save_file.store_line(str("CR:", cr_data))
			print(str("CR:", cr_data))
	
	save_file.close()

func _on_run_pressed():
	save()
	var read_file = FileAccess.open(level_data_file, FileAccess.READ)
	read_file.close()

func _on_save_file_name_pressed():
	if name_file_text.text != null and name_file_text.text != "":
		level_name = name_file_text.text
		save()
	name_file_ui.visible = false

func _on_cancel_file_name_pressed():
	name_file_ui.visible = false

func _process(delta):
	if name_file_text.text != null and name_file_text.text != "":
		$CanvasLayer/NameFile/SaveFileName.disabled = false
	else:
		$CanvasLayer/NameFile/SaveFileName.disabled = true
