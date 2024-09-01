extends CharacterBody2D

var sfx_anticipate = preload("res://audio/sfx/stalactite_anticipate.ogg")
var sfx_fall = preload("res://audio/sfx/stalactite_fall.ogg")
var sfx_death = preload("res://audio/sfx/enemy_death.ogg")
var particles_death = preload("res://scenes/particles/enemy_death.tscn")

@export var particles : PackedScene

var fall := false
var level_editor_offset := Vector2(4, 0)
var on_screen := false

var frame = 0
var frame2 = 0

var player
var gravity = 500.0

var gravity_multiplier = 1
var gravity_tiles = []

func _ready():
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta):
	if player == null:
		player = get_tree().get_first_node_in_group("Player")
	
	if fall == true:
		velocity.y += gravity * gravity_multiplier * delta
		
		if is_on_floor():
			destroy()
	
	if gravity_tiles.is_empty():
		gravity_multiplier = 1
	else:
		gravity_multiplier = -1
	
	if frame == 1:
		telegraph()
	
	if frame2 == 1:
		AudioHandler.play_sfx(sfx_fall)
	
	if abs(player.global_position.x - global_position.x) < 96:
		frame += 1
	
	if abs(player.global_position.x - global_position.x) < 40:
		fall = true
		frame2 += 1
		
	
	move_and_slide()

func _on_hitbox_area_entered(area):
	if area.get_collision_layer_value(7) or area.get_collision_layer_value(9):
		destroy()

func destroy():
	AudioHandler.play_sfx(sfx_death)
	
	var pd = particles_death.instantiate()
	get_parent().add_child(pd)
	pd.global_position = global_position
	
	call_deferred("queue_free")

func get_level_editor_offset() -> Vector2:
	return level_editor_offset


func _on_visible_on_screen_enabler_2d_screen_entered():
	on_screen = true

func _on_visible_on_screen_enabler_2d_screen_exited():
	on_screen = false

func telegraph():
	AudioHandler.play_sfx(sfx_anticipate)
	var p = particles.instantiate()
	get_parent().add_child(p)
	p.global_position = global_position

func _on_hitbox_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is TileMap:
		var cell_pos = body.get_coords_for_body_rid(body_rid)
		var cell_data = body.get_cell_tile_data(0, cell_pos)
		
		if cell_data:
			if cell_data.get_custom_data("health") != 0:
				body.erase_cell(0, cell_pos)
			if cell_data.get_custom_data("no_gravity") == true:
				gravity_tiles.append(cell_pos)

func _on_hitbox_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body is TileMap:
		var cell_pos = body.get_coords_for_body_rid(body_rid)
		var cell_data = body.get_cell_tile_data(0, cell_pos)
		
		
		if cell_data.get_custom_data("no_gravity") == true:
			gravity_tiles.pop_front()
