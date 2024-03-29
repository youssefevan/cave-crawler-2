extends Area2D
class_name Bullet

@export var speed := 200.0
@export var hitstun_weight := 0.1

var is_on_screen := true

var sfx_hit = preload("res://audio/sfx/bullet_hit.ogg")

func _physics_process(delta):
	global_position += Vector2(speed * delta, 0).rotated(rotation)

func _on_body_entered(body):
	if body is TileMap:
		explode()
		
	#elif body.get_collision_layer_value(2) or body.get_collision_layer_value(3):
		#call_deferred("queue_free")

func _on_area_exited(area):
	if area.get_collision_layer_value(5):
		call_deferred("queue_free")

func _on_area_entered(area):
	if area.get_collision_layer_value(7):
		if area.get_parent().is_in_group("Enemy"):
			explode()

func explode():
	if is_on_screen:
		AudioHandler.play_sfx(sfx_hit)
	call_deferred("queue_free")

func _on_visible_on_screen_notifier_2d_screen_entered():
	is_on_screen = true

func _on_visible_on_screen_notifier_2d_screen_exited():
	is_on_screen = false
