extends State

var frame := 0

func enter():
	super.enter()
	frame = 0

func physics_update(delta):
	if abs(entity.global_position - entity.reset_position) < Vector2(2,2):
		entity.velocity = lerp(entity.velocity, Vector2.ZERO, 12 * delta)
		frame += 1
		if frame >= 60 * 1:
			return entity.adjust
	else:
		entity.movement_direction = (entity.reset_position - entity.global_position).normalized()
		entity.velocity = lerp(entity.velocity, entity.speed * entity.speed_modifier * entity.movement_direction, 5 * delta)
