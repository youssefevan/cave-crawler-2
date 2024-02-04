extends CharacterBody2D

var fall := false
var level_editor_offset := Vector2(4, 0)

var player

func _ready():
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta):
	if fall == true:
		velocity.y += 800.0 * delta
		
		if is_on_floor():
			call_deferred("queue_free")
	
	if abs(player.global_position.x - global_position.x) < 40:
		fall = true
	
	move_and_slide()

func _on_hitbox_area_entered(area):
	if area.get_collision_layer_value(7):
		call_deferred("queue_free")

func get_level_editor_offset() -> Vector2:
	return level_editor_offset
