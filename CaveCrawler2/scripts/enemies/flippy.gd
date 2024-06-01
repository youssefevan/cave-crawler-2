extends Enemy

var can_flip := true

func _ready():
	super._ready()
	$Animator.play("Idle")

func _physics_process(delta):
	super._physics_process(delta)
	
	velocity.y += gravity * delta
	
	if is_on_floor() or is_on_ceiling():
		if can_flip:
			flip()
	
	move_and_slide()

func flip():
	can_flip = false
	
	gravity *= -1
	$Sprite.flip_v = !$Sprite.flip_v
	
	await get_tree().create_timer(0.1).timeout
	can_flip = true

func enter_bounce(bounce_force):
	pass
