extends State

var done := false

var delay := 0.5

func enter():
	super.enter()
	done = false
	await get_tree().create_timer(3).timeout
	entity.animator.play("Spawn")
	entity.spawn_knives()
	await get_tree().create_timer(2).timeout
	done = true

func physics_update(delta):
	super.physics_update(delta)
	
	entity.global_position.x = lerpf(entity.global_position.x, entity.player.global_position.x, 2 * delta)
	entity.global_position.y = lerpf(entity.global_position.y, entity.start_height, 2 * delta)
	
	if done == true:
		return entity.idle

func exit():
	super.exit()
	entity.animator.play("Idle")
