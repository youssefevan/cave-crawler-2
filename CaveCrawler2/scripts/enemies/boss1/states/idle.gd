extends State

var frame := 0

func enter():
	super.enter()
	frame = 0
	randomize()

func physics_update(delta):
	frame += 1
	if frame >= 60 * 4:
		var random = RandomNumberGenerator.new()
		random.randomize()
		if random.randi_range(0, 1) == 0:
			return entity.adjust
		else:
			return entity.chase
	
	var move_dir = Vector2(
			entity.player.position.x - entity.global_position.x,
			entity.reset_position.y - entity.global_position.y
		).normalized()
	
	if abs(entity.global_position.x - entity.player.position.x) < 24:
		entity.velocity = lerp(entity.velocity, Vector2.ZERO, 5 * delta)
	else:
		entity.velocity = lerp(entity.velocity, entity.speed * 0.3 * move_dir, 5 * delta)
