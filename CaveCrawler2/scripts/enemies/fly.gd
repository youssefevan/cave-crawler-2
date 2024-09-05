extends Enemy
class_name Fly

var speed := 110.0
var move_direction := 1
var acceleration := 3.0

var flea = preload("res://scenes/enemies/flea.tscn")


var frame := 0

func _ready():
	super._ready()
	$Animator.play("Fly")

func _physics_process(delta):
	super._physics_process(delta)
	
	frame += 1
	
	if frame == 1:
		drop()
	
	if player:
		if (global_position.x - player.global_position.x) > 0:
			move_direction = -1
			$Sprite.flip_h = false
		else:
			move_direction = 1
			$Sprite.flip_h = true
	
	velocity.x = lerpf(velocity.x, speed * move_direction, acceleration * delta)
	
	move_and_slide()

func drop():
	await get_tree().create_timer(1).timeout
	var f = flea.instantiate()
	$FleaCarrier.add_child(f)
	await get_tree().create_timer(3).timeout
	var f2 = flea.instantiate()
	get_parent().add_child(f2)
	f2.global_position = f.global_position
	f2.velocity.x = velocity.x
	f2.waiting = false
	$FleaCarrier.remove_child(f)
	drop()
