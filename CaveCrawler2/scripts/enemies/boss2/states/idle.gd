extends State

var anim_end := false
var end := false

func enter():
	super.enter()
	#entity.animator.play("Idle")
	
	entity.can_fire = true
	anim_end = false
	end = false
	await get_tree().create_timer(3).timeout
	AudioHandler.play_sfx(entity.sfx_transform)
	end = true

func physics_update(delta):
	super.physics_update(delta)
	
	shoot()
	
	entity.velocity.x = lerp(entity.velocity.x, 0.0, 3 * delta)
	
	if end == true:
		entity.animator.play("Transform")
	
	if anim_end == true:
		return entity.chase

func shoot():
	if entity.can_fire == true:
		entity.can_fire = false
		var b = entity.bullet.instantiate()
		get_tree().get_root().add_child(b)
		b.global_position = entity.muzzle.global_position
		b.rotation = entity.muzzle.rotation
		
		AudioHandler.play_sfx(entity.sfx_shoot)
		
		await get_tree().create_timer(entity.fire_rate).timeout
		entity.can_fire = true

func _on_animator_animation_finished(anim_name):
	if anim_name == "Transform":
		anim_end = true
