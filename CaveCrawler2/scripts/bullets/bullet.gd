extends Area2D
class_name Bullet

@export var speed := 200.0
@export var hitstun_weight := 0.1

@export var hit_flash : PackedScene

var sfx_hit = preload("res://audio/sfx/bullet_hit.ogg")

func _physics_process(delta):
	global_position += Vector2(speed * delta, 0).rotated(rotation)

func _on_body_shape_entered(body_rid, body, _body_shape_index, _local_shape_index):
	if body is TileMap:
		var cell_pos = body.get_coords_for_body_rid(body_rid)
		var cell_data = body.get_cell_tile_data(0, cell_pos)
		
		if cell_data:
			if cell_data.get_custom_data("does_damage") == true:
				pass
			elif cell_data.get_custom_data("health") != 0:
				damage_tile(body, cell_data, cell_pos)
				explode()
			else:
				explode()
		else:
			explode()

func damage_tile(body, cell_data, cell_pos):
	if cell_data.get_custom_data("health") == 2:
		body.set_cell(0, cell_pos, 2, Vector2(1, 6))
	elif cell_data.get_custom_data("health") == 1:
		body.set_cell(0, cell_pos, 2, Vector2(2, 6))
	elif cell_data.get_custom_data("health") == -1:
		body.erase_cell(0, cell_pos)

func _on_area_exited(area):
	if area.get_collision_layer_value(5):
		call_deferred("queue_free")

func _on_area_entered(area):
	if area.get_collision_layer_value(7):
		if area.get_parent().is_in_group("Enemy"):
			explode()

func explode():
	AudioHandler.play_sfx(sfx_hit)
	
	var flash = hit_flash.instantiate()
	get_tree().get_root().add_child(flash)
	flash.global_position = position
	
	call_deferred("queue_free")

func _on_visible_on_screen_notifier_2d_screen_exited():
	call_deferred("queue_free")
