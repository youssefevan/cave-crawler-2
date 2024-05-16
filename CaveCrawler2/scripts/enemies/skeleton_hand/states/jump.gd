extends State

func enter():
	super.enter()
	entity.velocity.y = -entity.jump_velocity * entity.speed_modifier
	entity.hitbox_collider.disabled = false
	entity.hurtbox_collider.disabled = false
	
	spawn_particles()

func physics_update(delta):
	if entity.grab == true:
		entity.animator.play("Grab")

func spawn_particles():
	var p = entity.particles_jump.instantiate()
	entity.get_parent().add_child(p)
	p.global_position = entity.global_position
