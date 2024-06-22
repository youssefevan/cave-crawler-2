extends Enemy

var speed := 60.0

func _ready():
	super._ready()
	$Animator.play("Spawn")

func _physics_process(delta):
	var movement_direction = (player.global_position - (global_position + Vector2(0, 8))).normalized()
	velocity = lerp(velocity, speed * movement_direction, 5 * delta)
	move_and_slide()
	
	if (global_position.x - player.global_position.x) > 0:
		$Sprite.scale.x = 1
	else:
		$Sprite.scale.x = -1
