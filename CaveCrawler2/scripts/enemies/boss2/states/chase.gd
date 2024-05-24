extends State

var end := false

func enter():
	super.enter()
	#entity.animator.play("Chase")
	
	end = false
	await get_tree().create_timer(4).timeout
	end = true

func physics_update(delta):
	super.physics_update(delta)
	entity.velocity.y = clampf(entity.velocity.y, -250.0, 250.0)
	
	if entity.player:
		if (entity.global_position.x - entity.player.global_position.x) > 0:
			entity.move_direction = -1
			#$Sprite.flip_h = false
		else:
			entity.move_direction = 1
			#$Sprite.flip_h = true
	
	entity.velocity.x = lerpf(entity.velocity.x, entity.speed * entity.move_direction, entity.acceleration * delta)
	
	if end == true:
		return entity.idle
