extends State

func enter():
	super.enter()

func physics_update(delta):
	entity.movement_direction = (entity.player.global_position - (entity.global_position + Vector2(0, 8))).normalized()
	entity.velocity = lerp(entity.velocity, entity.speed * entity.speed_modifier * entity.movement_direction, 5 * delta)
