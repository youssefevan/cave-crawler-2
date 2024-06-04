extends CharacterBody2D
class_name Enemy

@export var max_health : int
@export var gravity := 800.0
@export var level_editor_offset := Vector2(4, -8)

var player : Player

var sfx_death = preload("res://audio/sfx/enemy_death.ogg")

var current_health : int
var can_get_hurt : bool

var gravity_multiplier := 0.0
var gravity_tiles = []

func _ready():
	$Sprite.material.set_shader_parameter("enabled", false)
	current_health = max_health
	can_get_hurt = true
	
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta):
	if player == null:
		player = get_tree().get_first_node_in_group("Player")
	
	if gravity_tiles.is_empty():
		gravity_multiplier = 1.0
	else:
		gravity_multiplier = -1.0

func enter_bounce(bounce_force):
	velocity.y -= bounce_force

func get_hurt(hitstun_weight):
	if can_get_hurt:
		can_get_hurt = false
		
		current_health -= 1
		
		if current_health == 0:
			die()
		
		$Sprite.material.set_shader_parameter("enabled", true)
		set_physics_process(false)
		await get_tree().create_timer(hitstun_weight).timeout
		set_physics_process(true)
		$Sprite.material.set_shader_parameter("enabled", false)
		
		$Hurtbox/Collider.disabled = true
		can_get_hurt = true
		$Hurtbox/Collider.disabled = false

func die():
	AudioHandler.play_sfx(sfx_death)
	call_deferred("queue_free")

func _on_hurtbox_area_entered(area):
	if area.is_in_group("Player"):
		get_hurt(area.hitstun_weight)
	elif area.is_in_group("Hazard"):
		get_hurt(0.1)

func get_level_editor_offset() -> Vector2:
	return level_editor_offset

func _on_hurtbox_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is TileMap:
		var cell_pos = body.get_coords_for_body_rid(body_rid)
		var cell_data = body.get_cell_tile_data(0, cell_pos)
			
		if cell_data.get_custom_data("killzone") == true:
			current_health = 0
			die()
		elif cell_data.get_custom_data("does_damage") == true:
			get_hurt(0.1)
		elif cell_data.get_custom_data("no_gravity") == true:
			gravity_tiles.append(cell_pos)

func _on_hurtbox_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body is TileMap:
		var cell_pos = body.get_coords_for_body_rid(body_rid)
		var cell_data = body.get_cell_tile_data(0, cell_pos)
			
		if cell_data.get_custom_data("no_gravity") == true:
			gravity_tiles.pop_front()
