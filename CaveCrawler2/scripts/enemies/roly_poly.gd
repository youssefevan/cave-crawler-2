extends Enemy
class_name RolyPoly

var speed := 160.0
var acceleration := 1.0

var move_direction := -1

var player

func _ready():
	super._ready()
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_on_floor():
		velocity.y = 1
	
	velocity.y = clampf(velocity.y, -250.0, 250.0)
	
	if (global_position.x - player.global_position.x) > 0:
		move_direction = -1
		$Sprite.flip_h = false
	else:
		move_direction = 1
		$Sprite.flip_h = true
	
	velocity.x = lerpf(velocity.x, speed * move_direction, acceleration * delta)
	
	$Animator.play("Roll")
	
	move_and_slide()
