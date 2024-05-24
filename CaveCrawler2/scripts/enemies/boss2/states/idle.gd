extends State

var end := false

func enter():
	super.enter()
	#entity.animator.play("Idle")
	
	end = false
	await get_tree().create_timer(2).timeout
	end = true

func physics_update(delta):
	super.physics_update(delta)
	
	entity.velocity.x = lerp(entity.velocity.x, 0.0, 2 * delta)
	
	if end == true:
		return entity.chase
