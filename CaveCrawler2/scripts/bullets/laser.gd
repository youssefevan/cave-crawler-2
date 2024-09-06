extends Area2D

var player

var sfx_spawn = preload("res://audio/sfx/boss3/boss3_laser_spawn.ogg")
var sfx_shoot = preload("res://audio/sfx/boss3/boss3_laser_shoot.ogg")

func _ready():
	$Animator.play("Laser")
	
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta):
	if player == null:
		player = get_tree().get_first_node_in_group("Player")

func _on_animator_animation_finished(anim_name):
	call_deferred("queue_free")

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is TileMap:
		var cell_pos = body.get_coords_for_body_rid(body_rid)
		var cell_data = body.get_cell_tile_data(0, cell_pos)
		
		if cell_data.get_custom_data("health") != 0:
			body.erase_cell(0, cell_pos)

func camera_shake():
	player.apply_camera_shake()
	play_shoot_sfx()

func play_spawn_sfx():
	AudioHandler.play_sfx(sfx_spawn)

func play_shoot_sfx():
	AudioHandler.play_sfx(sfx_shoot)
