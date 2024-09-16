extends State

func enter():
	super.enter()

func physics_update(_delta):
	if abs(entity.player.global_position.x - entity.global_position.x) < 50:
		return entity.fly
