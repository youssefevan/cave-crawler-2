extends Node2D

@onready var tiles = $TileMap

# Terrain Coordinates
@export var ground := Vector2(1, 0)
@export var slope_left := Vector2(2, 0)
@export var slope_right := Vector2(3, 0)
@export var one_way := Vector2(4, 0)

# Enemy Coordinates
@export var rat := Vector2(0, 1)
@export var crab := Vector2(1, 1)
@export var bat := Vector2(2, 1)
@export var skeleton_hand := Vector2(3, 1)
@export var slug := Vector2(4, 1)
@export var turret := Vector2(5, 1)
@export var roly_poly := Vector2(6, 1)

# Hazard Coordinates
@export var spike := Vector2(0, 2)
@export var stalactite := Vector2(1, 2)
@export var lava := Vector2(2, 2)
@export var sludge := Vector2(3, 2)

# Utility Coordinates
@export var player := Vector2(0, 4)
@export var flagpole := Vector2(3, 4)

# Pickup Coordinates
@export var health := Vector2(0, 3)

# Utility scenes
var player_scene = Global.player_scene
@export var camera_room_scene : PackedScene
@export var flagpole_scene : PackedScene

# Enemy scenes
@export var rat_scene : PackedScene
@export var crab_scene : PackedScene
@export var bat_scene : PackedScene
@export var skeleton_hand_scene : PackedScene
@export var slug_scene : PackedScene
@export var turret_scene : PackedScene
@export var roly_poly_scene : PackedScene

# Hazard scenes
@export var spike_scene : PackedScene
@export var stalactite_scene : PackedScene

# Pickup scnes
@export var health_scene : PackedScene

#var player_in_level := false

var tile_size := 8
var tileset_id := 2

@export var level_path : String

var lines : Array
var camera_rooms : Array

func _ready():
	print(level_path)
	level_path = Global.level_to_load
	load_file()
	build_level()

func load_file():
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

func build_level():
	var autotile_cells : Array
	
	for cell in lines:
		var cell_type = Vector2(cell.z, cell.w)
		var cell_position = Vector2(cell.x, cell.y)
		match cell_type:
			ground:
				autotile_cells.append(cell_position)
			slope_left:
				tiles.set_cell(0, cell_position, tileset_id, Vector2(0,4))
			slope_right:
				tiles.set_cell(0, cell_position, tileset_id, Vector2(1,4))
			one_way:
				tiles.set_cell(0, cell_position, tileset_id, Vector2(2,4))
			player:
				spawn_entity(player_scene, cell_position)
			rat:
				spawn_entity(rat_scene, cell_position)
			crab:
				spawn_entity(crab_scene, cell_position)
			bat:
				spawn_entity(bat_scene, cell_position)
			skeleton_hand:
				spawn_entity(skeleton_hand_scene, cell_position)
			slug:
				spawn_entity(slug_scene, cell_position)
			turret:
				spawn_entity(turret_scene, cell_position)
			roly_poly:
				spawn_entity(roly_poly_scene, cell_position)
			spike:
				spawn_entity(spike_scene, cell_position)
			stalactite:
				spawn_entity(stalactite_scene, cell_position)
			health:
				spawn_entity(health_scene, cell_position)
			flagpole:
				spawn_entity(flagpole_scene, cell_position)
			lava:
				tiles.set_cell(0, cell_position, tileset_id, Vector2(2,5))
			sludge:
				tiles.set_cell(0, cell_position, tileset_id, Vector2(3,5))
	
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
	if e.has_method("get_level_editor_offset"):
		e.global_position = (spawn_position * tile_size) + e.get_level_editor_offset()
	else:
		e.global_position = spawn_position * tile_size
