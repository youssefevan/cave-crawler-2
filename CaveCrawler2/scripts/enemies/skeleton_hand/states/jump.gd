extends State

func enter():
	super.enter()
	entity.velocity.y = -entity.jump_velocity * entity.speed_modifier
	entity.hitbox_collider.disabled = false
	entity.hurtbox_collider.disabled = false

func physics_update(delta):
	if entity.grab == true:
		entity.animator.play("Grab")
