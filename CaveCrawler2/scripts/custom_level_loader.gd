extends Node2D

@onready var tiles = $TileMap
@export var image : CompressedTexture2D

# Utility colors
@export var player : Color
@export var ground : Color
@export var slope_left : Color
@export var slope_right : Color

# Enemy colors
@export var rat : Color
@export var crab : Color
@export var bat : Color
@export var skeleton_hand : Color

# Harard colors
@export var spike : Color
@export var stalactite : Color

# Utility scenes
@export var player_instance : PackedScene
@export var camera_room_instance : PackedScene

# Enemy scenes
@export var rat_instance : PackedScene
@export var crab_instance : PackedScene
@export var bat_instance : PackedScene
@export var skeleton_hand_instance : PackedScene

# Hazard scenes
@export var spike_instance : PackedScene
@export var stalactite_instance : PackedScene


var player_in_level := false

var tile_size := 8
var tileset_id := 2

func _ready():
	var data = image.get_image()
	
	var autotile_cells = []
	for x in data.get_size().x:
		for y in data.get_size().y:
			if data.get_pixel(x, y) == player:
				if not player_in_level:
					var p = player_instance.instantiate()
					add_child(p)
					p.global_position = Vector2(x, y) * tile_size
					player_in_level = true
				
			elif data.get_pixel(x, y) == rat:
				var r = rat_instance.instantiate()
				add_child(r)
				r.global_position = Vector2(x, y) * tile_size
				
			elif data.get_pixel(x, y) == crab:
				var c = crab_instance.instantiate()
				add_child(c)
				c.global_position = Vector2(x, y) * tile_size
				
			elif data.get_pixel(x, y) == bat:
				var b = bat_instance.instantiate()
				add_child(b)
				b.global_position = Vector2(x, y) * tile_size
				
			elif data.get_pixel(x, y) == skeleton_hand:
				var sh = skeleton_hand_instance.instantiate()
				add_child(sh)
				sh.global_position = Vector2(x, y) * tile_size
				
			elif data.get_pixel(x, y) == spike:
				var s = spike_instance.instantiate()
				add_child(s)
				s.global_position = Vector2(x, y) * tile_size
				
			elif data.get_pixel(x, y) == stalactite:
				var s = stalactite_instance.instantiate()
				add_child(s)
				s.global_position = Vector2(x, y) * tile_size
				
			elif data.get_pixel(x, y) == ground:
				autotile_cells.append(Vector2(x,y))
				
			elif data.get_pixel(x, y) == slope_left:
				tiles.set_cell(0, Vector2(x, y), tileset_id, Vector2(0,4))
				
			elif data.get_pixel(x, y) == slope_right:
				tiles.set_cell(0, Vector2(x, y), tileset_id, Vector2(1,4))
				
			elif data.get_pixel(x, y).a != 0:
				print(data.get_pixel(x, y))
				autotile_cells.append(Vector2(x, y))
				var cr = camera_room_instance.instantiate()
				add_child(cr)
				cr.global_position = Vector2(x, y) * tile_size
				cr.scale.x = (data.get_pixel(x, y).g * 255.0) * tile_size
				cr.scale.y = (data.get_pixel(x, y).b * 255.0) * tile_size
	
	tiles.set_cells_terrain_connect(0, autotile_cells, 0, 2)
