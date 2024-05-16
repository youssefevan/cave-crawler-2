extends CharacterBody2D

var sfx_death = preload("res://audio/sfx/enemy_death.ogg")
@export var particles : PackedScene

var fall := false
var level_editor_offset := Vector2(4, 0)
var on_screen := false

var frame = 0

var player
var gravity = 500.0

func _ready():
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta):
	if player == null:
		player = get_tree().get_first_node_in_group("Player")
	
	if fall == true:
		velocity.y += gravity * delta
		
		if is_on_floor():
			AudioHandler.play_sfx(sfx_death)
			call_deferred("queue_free")
	
	if frame == 1:
		telegraph()
	
	if abs(player.global_position.x - global_position.x) < 64:
		frame += 1
	
	if abs(player.global_position.x - global_position.x) < 40:
		fall = true
	
	move_and_slide()

func _on_hitbox_area_entered(area):
	if area.get_collision_layer_value(7):
		call_deferred("queue_free")

func get_level_editor_offset() -> Vector2:
	return level_editor_offset


func _on_visible_on_screen_enabler_2d_screen_entered():
	on_screen = true

func _on_visible_on_screen_enabler_2d_screen_exited():
	on_screen = false

func telegraph():
	var p = particles.instantiate()
	get_parent().add_child(p)
	p.global_position = global_position
