extends State

func enter():
	super.enter()
	AudioHandler.play_sfx(entity.sfx_chirp)

func physics_update(delta):
	entity.movement_direction = (entity.player.global_position - (entity.global_position + Vector2(0, 16))).normalized()
	entity.velocity = lerp(entity.velocity, entity.speed * entity.movement_direction, 2 * delta)
