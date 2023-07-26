extends Node2D

@onready var tiles = $TileMap
@export var image : CompressedTexture2D

@export var ground : Color
@export var rat : Color
@export var player : Color
@export var slope_left : Color
@export var slope_right : Color

@export var rat_instance : PackedScene
@export var player_instance : PackedScene
@export var camera_room_instance : PackedScene

var tile_size := 8

func _ready():
	var data = image.get_image()
	
	for x in data.get_size().x:
		for y in data.get_size().y:
			if data.get_pixel(x, y) == ground:
				tiles.set_cell(0, Vector2(x, y), 0, Vector2(1,1))
				
			elif data.get_pixel(x, y) == slope_left:
				tiles.set_cell(0, Vector2(x, y), 0, Vector2(4,0))
				
			elif data.get_pixel(x, y) == slope_right:
				tiles.set_cell(0, Vector2(x, y), 0, Vector2(5,0))
				
			elif data.get_pixel(x, y) == rat:
				var r = rat_instance.instantiate()
				add_child(r)
				r.global_position = Vector2(x, y) * tile_size
				
			elif data.get_pixel(x, y) == player:
				var p = player_instance.instantiate()
				add_child(p)
				p.global_position = Vector2(x, y) * tile_size
				
			elif data.get_pixel(x, y).a != 0:
				tiles.set_cell(0, Vector2(x, y), 0, Vector2(1,1))
				var cr = camera_room_instance.instantiate()
				add_child(cr)
				cr.global_position = Vector2(x, y) * tile_size
				cr.scale.x = (data.get_pixel(x, y).g * 255.0) * tile_size
				cr.scale.y = (data.get_pixel(x, y).b * 255.0) * tile_size
