extends Node2D

@export var custom_level_loader : PackedScene

@onready var tiles = $TileMap

var tile_size = 8
var tileset_coordinates : Vector2

var level_path : String

var new_level : bool

var lines : Array
var camera_rooms : Array

var camera_room_tool_coordinates := Vector2(1, 4)
@export var camera_room_tool_scene : PackedScene

func _ready():
	if new_level != true:
		load_existing_level()

func _on_tool_selected(tool_coordinates, tool_type):
	tileset_coordinates = tool_coordinates

func _input(event):
	if event is InputEvent:
		if Input.is_action_just_pressed("save_level"):
			save()

func _process(delta):
	$ToolPreview.frame_coords = tileset_coordinates
	$ToolPreview.global_position = Vector2(floor(get_local_mouse_position() / tile_size) + Vector2(.5, .5)) * tile_size

func _unhandled_input(event):
	var mouse_position_rounded = Vector2(floor(get_local_mouse_position() / tile_size))
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if tileset_coordinates != camera_room_tool_coordinates:
			tiles.set_cell(0, mouse_position_rounded, 3, tileset_coordinates)
			
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		tiles.erase_cell(0, mouse_position_rounded)
	
	if Input.is_action_just_pressed("place_tile"):
		if tileset_coordinates == camera_room_tool_coordinates:
			place_camera_room_tool(mouse_position_rounded * tile_size)

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
	save()

func save():
	var used_cells = tiles.get_used_cells(0)
	var save_file = FileAccess.open(level_path, FileAccess.WRITE)
	
	for cell in used_cells.size():
		var cell_coords = used_cells[cell]
		var cell_type = tiles.get_cell_atlas_coords(0, used_cells[cell])
		var cell_data = Vector4(cell_coords.x, cell_coords.y, cell_type.x, cell_type.y)
		save_file.store_line(str(cell_data))
#		print(cell_data)
	
	for child in get_children():
		if child is CameraRoomTool:
			var cr_data = Vector4(child.global_position.x, child.global_position.y, child.size.x, child.size.y)
			save_file.store_line(str(cr_data, ",CR"))
#			print(str(cr_data, ",CR"))
	
	save_file.close()

func _on_run_pressed():
	save()
	var read_file = FileAccess.open(level_path, FileAccess.READ)
	read_file.close()
	
	load_level()

func load_level():
	var cll = custom_level_loader.instantiate()
	cll.level_path = level_path
	get_tree().get_root().add_child(cll)
	call_deferred("queue_free")

func load_existing_level():
	var file = FileAccess.open(level_path, FileAccess.READ)
	
	for line in file.get_as_text(false).split("\n"):
		var count := 0
		var line_vector : Vector4
		var is_camera_room := false
		for char in line.split(","):
			count += 1
			
			var char_to_int
			if char != "CR":
				char_to_int = char.to_int()
			
			match count:
				1:
					line_vector.x = char_to_int
				2:
					line_vector.y = char_to_int
				3:
					line_vector.z = char_to_int
				4:
					line_vector.w = char_to_int
				5:
					is_camera_room = true
			
		if is_camera_room == true:
			camera_rooms.append(line_vector)
		else:
			lines.append(line_vector)
			
	file.close()
	build_level()

func build_level():
	for cell in lines:
		var cell_type = Vector2(cell.z, cell.w)
		var cell_position = Vector2(cell.x, cell.y)
		tiles.set_cell(0, cell_position, 3, cell_type)
	
	for room in camera_rooms:
		build_camera_room_tool(Vector2(room.x, room.y), Vector2(room.z, room.w))

func build_camera_room_tool(coordinates, size):
	var c = camera_room_tool_scene.instantiate()
	add_child(c)
	c.global_position = coordinates
	c.width.value = size.x / tile_size
	c.height.value = size.y / tile_size
