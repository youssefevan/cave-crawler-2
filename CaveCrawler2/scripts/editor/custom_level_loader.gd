extends Node2D

@onready var tiles = $TileMap

# Terrain Coordinates
var ground := Vector2(1, 0)
var ground2 := Vector2(2, 0)
var ground3 := Vector2(3, 0)
var slope_left := Vector2(4, 0)
var slope_right := Vector2(5, 0)
var one_way := Vector2(6, 0)
var destructible := Vector2(7, 0)

# Enemy Coordinates
var rat := Vector2(0, 1)
var crab := Vector2(1, 1)
var bat := Vector2(2, 1)
var skeleton_hand := Vector2(3, 1)
var slug := Vector2(4, 1)
var turret := Vector2(5, 1)
var roly_poly := Vector2(6, 1)
var slug_cluster := Vector2(7, 1)
var flippy := Vector2(8, 1)
var fly := Vector2(9, 1)

# Hazard Coordinates
var spike := Vector2(0, 2)
var stalactite := Vector2(1, 2)
var lava := Vector2(2, 2)
var anti_gravity := Vector2(3, 2)

# Utility Coordinates
var player := Vector2(0, 4)
var checkpoint := Vector2(2, 4)
var flagpole := Vector2(3, 4)

# Pickup Coordinates
var health := Vector2(4, 4)

# Utility scenes
var player_scene = Global.player_scene
@export var camera_room_scene : PackedScene
@export var moving_platform_scene : PackedScene
@export var checkpoint_scene : PackedScene
@export var flagpole_scene : PackedScene

# Enemy scenes
@export var rat_scene : PackedScene
@export var crab_scene : PackedScene
@export var bat_scene : PackedScene
@export var skeleton_hand_scene : PackedScene
@export var slug_scene : PackedScene
@export var turret_scene : PackedScene
@export var roly_poly_scene : PackedScene
@export var slug_cluster_scene : PackedScene
@export var flippy_scene : PackedScene
@export var fly_scene : PackedScene

# Hazard scenes
@export var stalactite_scene : PackedScene

# Pickup scnes
@export var health_scene : PackedScene

#var player_in_level := false

var tile_size := 8
var tileset_id := 2

@export var level_path : String

var lines : Array
var camera_rooms : Array
var moving_platforms : Array

func _ready():
	#print(level_path)
	level_path = Global.level_to_load
	
	$Error.visible = false
	
	load_file()
	check_for_player()
	build_level()

func load_file():
	var file = FileAccess.open(level_path, FileAccess.READ)
	
	for line in file.get_as_text(false).split("\n"):
		var count := 0
		var line_vector : Vector4
		var is_camera_room := false
		var is_moving_platform := false
		for char in line.split(","):
			count += 1
			
			var char_to_int
			if char != "CR" and char != "MP":
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
					if char == "CR":
						is_camera_room = true
					elif char == "MP":
						is_moving_platform = true
			
		if is_camera_room == true:
			camera_rooms.append(line_vector)
		elif is_moving_platform == true:
			moving_platforms.append(line_vector)
		else:
			lines.append(line_vector)
			
	file.close()

func check_for_player():
	var player_found = false
	for cell in lines:
		if Vector2(cell.z, cell.w) == player:
			player_found = true
			break
	#print(player_found)
	
	if player_found == false:
		$Error.visible = true
		$Error/VBoxContainer/Okay.grab_focus()

func build_level():
	var world_1_cells : Array
	var world_2_cells : Array
	var world_3_cells : Array
	
	for cell in lines:
		var cell_type = Vector2(cell.z, cell.w)
		var cell_position = Vector2(cell.x, cell.y)
		match cell_type:
			ground:
				world_1_cells.append(cell_position)
			ground2:
				world_2_cells.append(cell_position)
			ground3:
				world_3_cells.append(cell_position)
			slope_left:
				tiles.set_cell(0, cell_position, tileset_id, Vector2(0, 4))
			slope_right:
				tiles.set_cell(0, cell_position, tileset_id, Vector2(1, 4))
			one_way:
				tiles.set_cell(0, cell_position, tileset_id, Vector2(2, 4))
			destructible:
				tiles.set_cell(0, cell_position, tileset_id, Vector2(0, 6))
			player:
				if get_tree().get_node_count_in_group("Player") == 0:
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
			slug_cluster:
				spawn_entity(slug_cluster_scene, cell_position)
			flippy:
				spawn_entity(flippy_scene, cell_position)
			fly:
				spawn_entity(fly_scene, cell_position)
			stalactite:
				spawn_entity(stalactite_scene, cell_position)
			health:
				spawn_entity(health_scene, cell_position)
			checkpoint:
				spawn_entity(checkpoint_scene, cell_position)
			flagpole:
				spawn_entity(flagpole_scene, cell_position)
			spike:
				tiles.set_cell(0, cell_position, tileset_id, Vector2(3,4))
			lava:
				tiles.set_cell(0, cell_position, tileset_id, Vector2(4,4))
			anti_gravity:
				tiles.set_cell(0, cell_position, tileset_id, Vector2(4,6))
	
	tiles.set_cells_terrain_connect(0, world_1_cells, 0, 0)
	tiles.set_cells_terrain_connect(0, world_2_cells, 0, 1)
	tiles.set_cells_terrain_connect(0, world_3_cells, 0, 2)
	
	for room in camera_rooms:
		spawn_camera_room(Vector2(room.x, room.y), Vector2(room.z, room.w))
	
	for mp in moving_platforms:
		spawn_moving_platform(Vector2(mp.x, mp.y), Vector2(mp.z, mp.w))

func spawn_camera_room(coordinates, size):
	var c = camera_room_scene.instantiate()
	add_child(c)
	c.global_position = coordinates
	c.scale = size

func spawn_moving_platform(start_coords, end_coords):
	var mp = moving_platform_scene.instantiate()
	mp.custom_level = true
	mp.start_position = start_coords + Vector2(16, 4)
	mp.end_position = end_coords + Vector2(16, 4)
	mp.global_position = start_coords + Vector2(16, 4)
	add_child(mp)

func spawn_entity(entity, spawn_position):
	var e = entity.instantiate()
	add_child(e)
	
	if entity == player_scene and Global.checkpoint_passed:
		e.global_position = Global.checkpoint_position
	else:
		if e.has_method("get_level_editor_offset"):
			e.global_position = (spawn_position * tile_size) + e.get_level_editor_offset()
		else:
			e.global_position = spawn_position * tile_size

func _on_okay_pressed():
	get_tree().change_scene_to_packed(Global.custom_level_interface_scene)
