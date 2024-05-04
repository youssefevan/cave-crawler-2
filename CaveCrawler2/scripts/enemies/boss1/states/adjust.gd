extends State

var frame := 0

func enter():
	super.enter()
	frame = 0

func physics_update(delta):
	frame += 1
	
	entity.movement_direction = (entity.player.global_position - (entity.global_position + Vector2(0, 8))).normalized()
	
	entity.velocity.x = lerpf(
		entity.velocity.x, entity.speed * entity.speed_modifier * entity.movement_direction.x, 5 * delta
	)
	entity.velocity.y = lerpf(
		entity.velocity.y, entity.speed * entity.speed_modifier * entity.movement_direction.y, 5 * delta
	)
	
	if frame >= 60 * 5:
		return entity.idle
