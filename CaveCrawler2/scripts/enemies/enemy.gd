extends CharacterBody2D
class_name Enemy

@export var max_health : int
@export var gravity := 800.0
@export var level_editor_offset := Vector2(4, -8)

var current_health : int
var can_get_hurt : bool

func _ready():
	$Sprite.material.set_shader_parameter("enabled", false)
	current_health = max_health
	can_get_hurt = true

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
		
		can_get_hurt = true

func die():
	call_deferred("queue_free")

func _on_hurtbox_area_entered(area):
	if area.is_in_group("Player"):
		get_hurt(area.hitstun_weight)
	elif area.is_in_group("Hazard"):
		get_hurt(0.1)

func _on_hurtbox_body_entered(body):
	if body is TileMap:
		var cell_pos = body.local_to_map(global_position)
		var cell_data = body.get_cell_tile_data(0, cell_pos)
		if cell_data.get_custom_data("killzone") == true:
			current_health = 0
			die()
		else:
			print(cell_data.get_custom_data("accel_modifier"))

func get_level_editor_offset() -> Vector2:
	return level_editor_offset
