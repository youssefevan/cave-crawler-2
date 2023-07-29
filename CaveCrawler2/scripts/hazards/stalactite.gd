extends CharacterBody2D

var fall := false

func _physics_process(delta):
	if fall == true:
		velocity.y += 800.0 * delta
		
		if is_on_floor():
			call_deferred("queue_free")
	
	move_and_slide()

func _on_player_detection_body_entered(body):
	if body.get_collision_layer_value(2):
		fall = true

func _on_hitbox_area_entered(area):
	if area.get_collision_layer_value(7):
		call_deferred("queue_free")
