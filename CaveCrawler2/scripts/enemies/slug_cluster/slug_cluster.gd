extends Enemy
class_name SlugCluster

var speed := 60.0
var movement_direction : Vector2

@onready var animator = $Animator

@export var slug_scene : PackedScene

var move_dir := 0

func _ready():
	super._ready()
	$Animator.play("Idle")

func _physics_process(delta):
	super._physics_process(delta)
	
	if (global_position.x - player.global_position.x > 0):
		move_dir = -1
		$Sprite.scale.x = 1
	else:
		move_dir = 1
		$Sprite.scale.x = -1
	
	velocity.x = lerpf(velocity.x, move_dir * speed * speed_modifier, 2 * delta)
	
	# gravity
	velocity.y += gravity * delta
	velocity.y = clampf(velocity.y, -250.0 * speed_modifier, 250.0 * speed_modifier)
	
	if is_on_floor():
		$Sprite.scale.y = 0.5
		#$Sprite.position.y = -4
		jump()
	else:
		$Sprite.scale.y = 1
		#$Sprite.position.y = 0
	
	move_and_slide()

func jump():
	velocity.y -= 140.0

func die():
	var s2 = slug_scene.instantiate()
	get_parent().add_child(s2)
	s2.global_position = global_position
	s2.velocity = Vector2(-100, -300)
	
	var s3 = slug_scene.instantiate()
	get_parent().add_child(s3)
	s3.global_position = global_position
	s3.velocity = Vector2(100, -300)
	
	super.die()
