extends State

func enter():
	super.enter()
	entity.hitbox_collider.disabled = true
	entity.hurtbox_collider.disabled = true

func physics_update(_delta):
	if entity.player_detected:
		return entity.jump
