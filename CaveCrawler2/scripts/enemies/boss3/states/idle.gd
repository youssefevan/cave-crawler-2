extends State

var done := false

func enter():
	super.enter()
	done = false
	#await get_tree().create_timer(1).timeout
	entity.shoot()
	await get_tree().create_timer(2).timeout
	done = true

func physics_update(delta):
	super.physics_update(delta)
	
	entity.velocity = Vector2.ZERO
	
	if done == true:
		return entity.chase
