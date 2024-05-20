extends Enemy
class_name RolyPoly

var speed := 160.0
var acceleration := 1.0

var move_direction := -1

func _ready():
	super._ready()

func _physics_process(delta):
	super._physics_process(delta)
	if not is_on_floor():
		velocity.y += gravity * speed_modifier * delta
	
	#if is_on_floor():
	#	velocity.y = 1
	
	velocity.y = clampf(velocity.y, -250.0 * speed_modifier, 250.0 * speed_modifier)
	
	if player:
		if (global_position.x - player.global_position.x) > 0:
			move_direction = -1
			$Sprite.flip_h = false
		else:
			move_direction = 1
			$Sprite.flip_h = true
	
	velocity.x = lerpf(velocity.x, speed * speed_modifier * move_direction, acceleration * delta)
	
	$Animator.play("Roll")
	
	move_and_slide()
