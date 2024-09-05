extends Enemy

var can_flip := true

var sfx_land = preload("res://audio/sfx/flippy_land.ogg")

func _ready():
	super._ready()
	#$Animator.play("Idle")

func _physics_process(delta):
	super._physics_process(delta)
	
	velocity.y += gravity * delta
	
	if is_on_floor() or is_on_ceiling():
		velocity.x = 0
		if can_flip:
			flip()
	
	move_and_slide()

func flip():
	AudioHandler.play_sfx(sfx_land)
	
	$Animator.play("Land")
	can_flip = false
	
	gravity *= -1
	$Sprite.flip_v = !$Sprite.flip_v
	
	await get_tree().create_timer(0.1).timeout
	can_flip = true

func enter_bounce(bounce_force):
	pass
	
func _on_hurtbox_area_entered(area):
	super._on_hurtbox_area_entered(area)
	if area.is_in_group("Player"):
		#if can_flip:
		flip()

func _on_hurtbox_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is TileMap:
		var cell_pos = body.get_coords_for_body_rid(body_rid)
		var cell_data = body.get_cell_tile_data(0, cell_pos)
		
		if cell_data:
			if cell_data and cell_pos:
				if cell_data.get_custom_data("health") != 0:
					damage_tile(body, cell_data, cell_pos)
			
			if cell_data.get_custom_data("killzone") == true:
				current_health = 0
				die()

func damage_tile(body, cell_data, cell_pos):
	if cell_data.get_custom_data("health") == 2:
		body.set_cell(0, cell_pos, 2, Vector2(1, 6))
	elif cell_data.get_custom_data("health") == 1:
		body.set_cell(0, cell_pos, 2, Vector2(2, 6))
	elif cell_data.get_custom_data("health") == -1:
		body.erase_cell(0, cell_pos)
