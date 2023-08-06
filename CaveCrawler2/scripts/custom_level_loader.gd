extends Node2D

@onready var tiles = $TileMap

# Utility colors
@export var player := Vector2(0, 4)
@export var ground := Vector2(1, 0)
@export var slope_left := Vector2(2, 0)
@export var slope_right := Vector2(3, 0)

# Enemy colors
@export var rat := Vector2(0, 1)
@export var crab : Color
@export var bat : Color
@export var skeleton_hand : Color

# Harard colors
@export var spike : Color
@export var stalactite : Color

# Utility scenes
@export var player_scene : PackedScene
@export var camera_room_scene : PackedScene

# Enemy scenes
@export var rat_scene : PackedScene
@export var crab_scene : PackedScene
@export var bat_scene : PackedScene
@export var skeleton_hand_scene : PackedScene

# Hazard scenes
@export var spike_scene : PackedScene
@export var stalactite_scene : PackedScene

var player_in_level := false

var tile_size := 8
var tileset_id := 2

@export var level_name : String
var level : String

var lines : Array
var camera_rooms : Array

@onready var load_file_ui = $CanvasLayer/LoadFileUI
@onready var load_file_text = $CanvasLayer/LoadFileUI/TextEdit

func _ready():
	load_file_ui.visible = false
	load_file()
	build_level()

func _process(delta):
	if load_file_text.text != null and load_file_text.text != "":
		$CanvasLayer/LoadFileUI/Load.disabled = false
	else:
		$CanvasLayer/LoadFileUI/Load.disabled = true

func load_file():
	var file_directory = str("res://", level_name, ".txt")
	var file = FileAccess.open(file_directory, FileAccess.READ)
	
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

func build_level():
	var autotile_cells : Array
	
	for cell in lines:
		print(cell)
		var cell_type = Vector2(cell.z, cell.w)
		var cell_position = Vector2(cell.x, cell.y)
		match cell_type:
			ground:
				autotile_cells.append(cell_position)
			slope_left:
				tiles.set_cell(0, cell_position, tileset_id, Vector2(0,4))
			slope_right:
				tiles.set_cell(0, cell_position, tileset_id, Vector2(1,4))
			player:
				spawn_entity(player_scene, cell_position)
			rat:
				spawn_entity(rat_scene, cell_position)
	
	tiles.set_cells_terrain_connect(0, autotile_cells, 0, 2)
	
	for room in camera_rooms:
		spawn_camera_room(Vector2(room.x, room.y), Vector2(room.z, room.w))

func spawn_camera_room(coordinates, size):
	var c = camera_room_scene.instantiate()
	add_child(c)
	c.global_position = coordinates
	c.scale = size

func spawn_entity(entity, spawn_position):
	var e = entity.instantiate()
	add_child(e)
	e.global_position = spawn_position * tile_size

func _on_load_pressed():
	if load_file_text.text != null and load_file_text.text != "":
		level_name = load_file_text.text
		load_file_ui.visible = false
		load_file()
		build_level()
