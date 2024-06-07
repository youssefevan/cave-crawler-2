extends State

var end := false

func enter():
	super.enter()
	end = false
	await get_tree().create_timer(2.5).timeout
	end = true

func physics_update(delta):
	entity.movement_direction = (entity.player.global_position - (entity.global_position + Vector2(0, 8))).normalized()
	entity.velocity = lerp(entity.velocity, entity.speed * .6 * entity.movement_direction, 5 * delta)
	
	if end == true:
		return entity.idle
