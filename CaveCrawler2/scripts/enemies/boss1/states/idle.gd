extends State

var frame := 0

func enter():
	super.enter()
	frame = 0
	randomize()

func physics_update(delta):
	if abs(entity.global_position.y - entity.reset_position.y) < 2:
		entity.velocity = lerp(entity.velocity, Vector2.ZERO, 12 * delta)
		frame += 1
		if frame >= 60 * 1:
			
			var random = RandomNumberGenerator.new()
			random.randomize()
			if random.randi_range(0, 1) == 0:
				return entity.adjust
			else:
				return entity.chase
			
	else:
		entity.movement_direction = (entity.reset_position - entity.global_position).normalized()
		entity.velocity.x = lerpf(entity.velocity.y, 0.0, 5 * delta)
		entity.velocity.y = lerpf(entity.velocity.y, entity.speed * entity.speed_modifier * entity.movement_direction.y, 5 * delta)
