extends State

var end := false
var anim_end := false

func enter():
	super.enter()
	#entity.animator.play("Chase")
	
	AudioHandler.play_sfx(entity.sfx_chase)
	
	end = false
	anim_end = false
	await get_tree().create_timer(4).timeout
	end = true
	await get_tree().create_timer(.4).timeout
	AudioHandler.play_sfx(entity.sfx_transform)

func physics_update(delta):
	super.physics_update(delta)
	
	if entity.player:
		if (entity.global_position.x - entity.player.global_position.x) > 0:
			entity.move_direction = -1
			#$Sprite.flip_h = false
		else:
			entity.move_direction = 1
			#$Sprite.flip_h = true
	
	
	if end == true:
		entity.animator.play_backwards("Transform")
		
		entity.velocity.x = lerpf(entity.velocity.x, 0.0, 3 * delta)
		
		if anim_end == true:
			return entity.idle
	else:
		entity.velocity.x = lerpf(entity.velocity.x, entity.speed * entity.move_direction, entity.acceleration * delta)

func _on_animator_animation_finished(anim_name):
	if anim_name == "Transform":
		anim_end = true
