extends Enemy
class_name Flea

var speed := 30.0
var acceleration := 5.0

var move_direction := -1

var waiting := true

func _ready():
	super._ready()
	$Animator.play("Bounce")

func _physics_process(delta):
	super._physics_process(delta)
	
	if waiting == false:
		velocity.y += gravity * gravity_multiplier * delta
		
		#if is_on_floor():
		#	velocity.y = 1
		
		velocity.y = clampf(velocity.y, -250.0, 250.0)
		
		if player:
			if (global_position.x - player.global_position.x) > 0:
				move_direction = -1
				$Sprite.flip_h = false
			else:
				move_direction = 1
				$Sprite.flip_h = true
		
		if is_on_floor():
			velocity.x = lerpf(velocity.x, speed * move_direction, acceleration * delta)
		else:
			velocity.x = lerpf(velocity.x, 0, 0.5 * delta)
		
		move_and_slide()


func get_hurt(hitstun_weight):
	if waiting == false:
		super.get_hurt(hitstun_weight)
