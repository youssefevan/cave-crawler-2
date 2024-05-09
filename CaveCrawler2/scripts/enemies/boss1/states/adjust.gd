extends State

var end := false

func enter():
	super.enter()
	entity.velocity.y = 0
	
	end = false
	await get_tree().create_timer(3).timeout
	end = true

func physics_update(delta):
	entity.movement_direction = (entity.player.global_position - (entity.global_position + Vector2(0, 8))).normalized()
	
	entity.velocity.x = lerpf(
		entity.velocity.x, entity.speed * entity.speed_modifier * entity.movement_direction.x, 5 * delta
	)
	
	if end:
		return entity.slam
