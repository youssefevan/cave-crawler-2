extends Enemy
class_name Boss3

@onready var animator = $Animator
@onready var states = $StateManager
@onready var idle = $StateManager/Idle
@onready var chase = $StateManager/Chase

@onready var laser = preload("res://scenes/bullets/laser.tscn")

var speed := 50.0

func _ready():
	super._ready()
	
	states.init(self)
	
	$Animator.play("Idle")

func _physics_process(delta):
	super._physics_process(delta)
	states.physics_update(delta)
	#face_player()
	move_and_slide()

func face_player():
	if (global_position.x - player.global_position.x) > 0:
		$Boss.flip_h = false
		$Sprite.scale.x = 1
		$Muzzle.position.x = -2
	else:
		$Boss.flip_h = true
		$Sprite.scale.x = -1
		$Muzzle.position.x = 2

func shoot():
	var l = laser.instantiate()
	get_parent().add_child.call_deferred(l)
	l.global_position = $Muzzle.global_position
	l.scale.x = -$Sprite.scale.x
