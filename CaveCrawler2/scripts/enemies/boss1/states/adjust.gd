extends State

var end := false

func enter():
	super.enter()
	entity.velocity.y = 0
	
	AudioHandler.play_sfx(entity.sfx_hover)
	
	end = false
	await get_tree().create_timer(3).timeout
	end = true

func physics_update(delta):
	entity.movement_direction = (entity.player.global_position - (entity.global_position + Vector2(0, 8))).normalized()
	
	entity.velocity.x = lerpf(
		entity.velocity.x, entity.speed * entity.movement_direction.x, 8 * delta
	)
	
	if end:
		return entity.slam

func exit():
	super.exit()
	#AudioHandler.clear_sfx(entity.sfx_hover)
