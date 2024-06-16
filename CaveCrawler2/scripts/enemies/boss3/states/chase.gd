extends State

var end := false

func enter():
	super.enter()
	end = false
	await get_tree().create_timer(1).timeout
	end = true

func physics_update(delta):
	super.physics_update(delta)
	entity.face_player()
	
	var movement_direction = (entity.player.global_position - (entity.global_position + Vector2(0, 16))).normalized()
	entity.velocity = lerp(entity.velocity, entity.speed * movement_direction, 5 * delta)
	
	if end == true:
		return entity.idle
